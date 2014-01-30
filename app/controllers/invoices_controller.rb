class InvoicesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Invoice, :message => I18n.t('global.unauthorized')

    @invoice = Invoice.new
  end

  def show
    authorize! :show, Invoice, :message => I18n.t('global.unauthorized')

    @invoice = Invoice.find(params[:id])
    @company = Company.find(params[:company_id])

    @entries = Entry.where(invoice_id: params[:id]).order('id ASC')

    @classes = Classifications.all
    @statuses = [I18n.t('invoice.controller.tested'),I18n.t('invoice.controller.repaired'),I18n.t('invoice.controller.scrapped')]
    @entry_data = Array.new
    @entry_status = Array.new
    (0..@classes.length).each do |i|
      @entry_data[i] = Array.new
    end
    (0..2).each do |i|
      @entry_status[i] = 0
    end
    @entries.each do |entry|
      @entry_data[entry.class_id].append(entry)
      if entry.scrap == 1
        @entry_status[2] = @entry_status[2] + 1
      elsif entry.repaired == 1
        @entry_status[1] = @entry_status[1] + 1
      elsif entry.test == 1
        @entry_status[0] = @entry_status[0] + 1
      end
    end

    @appliances = Appliance.all
    @sender_data = ENV["COMPANY"]
  end

  def index
    authorize! :index, Invoice, :message => I18n.t('global.unauthorized')

    @company = Company.find(params[:company_id])

    if can? :create, Entry or current_user.roles.first.name == params[:company_id].short
      @invoices = @company.invoices.order('id ASC').page(params[:page]).per(25)
    else
      redirect_to root_path, :alert => I18n.t('global.unauthorized')
    end
  end

  def destroy
    authorize! :destroy, Invoice, :message => I18n.t('global.unauthorized')

    entries = Entry.where(invoice_id: params[:id])
    entries.each do |entry|
      entry.update_attribute(:sent, 0)
      entry.update_attribute(:invoice_id, nil)
    end
    invoice = Invoice.find(params[:id])
    invoice.destroy
    redirect_to invoices_path, :notice => I18n.t('invoice.controller.deleted')
  end

  def create
    authorize! :create, Invoice, :message => I18n.t('global.unauthorized')

    items = params[:invoice][:items]
    params[:invoice][:items] = params[:invoice][:items].lines.length
    params[:invoice][:company_id] = params[:company_id]
    @invoice = Invoice.new(params[:invoice].permit(:items, :company_id))

    non_existing = Array.new
    already_sent = Array.new
    wrong_comp = Array.new
    items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      app = Appliance.where(abb: num[1]).take
      entry = Entry.where(company_id: params[:company_id], number: num[2..-1], appliance_id: app.id).take
      if entry.nil?
      	non_existing.push(num)
      elsif entry.sent.to_i == 1
      	already_sent.push(num)
      elsif entry.company_id != params[:company_id]
        wrong_comp.push(num)
      end
    end

    if non_existing.length == 0 and already_sent.length == 0 and wrong_comp.length == 0 and @invoice.save
      items.lines do |line|
        num = line.tr("\n","").tr("\r","")
        app = Appliance.where(abb: num[1]).take
        entry = Entry.where(company_id: params[:company_id], number: num[2..-1], appliance_id: app.id).take
        entry.update_attribute(:invoice_id, @invoice.id)
        entry.update_attribute(:sent, 1)
      end
      redirect_to company_invoices_path(params[:company_id]), :notice => I18n.t('invoice.controller.added')
    else
      non_existing.each do |item|
      	flash["alert #{item}"] = "#{item} #{I18n.t('invoice.controller.no_exist')}"
      end
      already_sent.each do |item|
      	flash["alert #{item}"] = "#{item} #{I18n.t('invoice.controller.already_sent')}"
      end
      wrong_comp.each do |item|
        flash["alert #{item}"] = "#{item} #{I18n.t('invoice.controller.wrong_company')} #{session[:company]}!"
      end
      render 'new'
    end
  end
end
