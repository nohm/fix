class InvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    permission = false
    unless current_user.nil? or params[:company_id].nil?
      if current_user.staff? or Company.where(short: current_user.roles.first.name).take.id == params[:company_id].to_i
        permission = true
      end
    end
    unless permission
      redirect_to root_path, :alert => I18n.t('global.unauthorized')
    end
  end

  def new
    authorize! :new, Invoice, :message => I18n.t('global.unauthorized')

    @invoice = Invoice.new
  end

  def show
    authorize! :show, Invoice, :message => I18n.t('global.unauthorized')

    if params[:slip] == 'slip' and cannot? :slip, Invoice
      redirect to root_path, :notice => I18n.t('global.unauthorized')
    end

    @invoice = Invoice.find(params[:id])
    @company = Company.find(params[:company_id])

    @classes = Classifications.all
    @statuses = [I18n.t('invoice.controller.tested'),I18n.t('invoice.controller.repaired'),I18n.t('invoice.controller.scrapped'),I18n.t('invoice.controller.skipped')]

    @entry_classes = Hash.new(Array.new)
    @classes.each do |klass|
      @entry_classes[klass.name] = Entry.includes(:type,:company).where(classifications_id: klass.id, invoice_id: @invoice.id).order('id ASC')
    end

    @price_type_total = Hash.new
    price_global_total = { I18n.t('invoice.controller.tested') => [0,0,-1], I18n.t('invoice.controller.repaired') => [0,0,-1], I18n.t('invoice.controller.scrapped') => [0,0,-1], I18n.t('invoice.controller.skipped') => [0,0,-1] }

    @types = Type.find(Entry.where(invoice_id: @invoice.id).select("DISTINCT type_id").map(&:type_id).sort!)
    @types.each_with_index do |type, index|
      price_total = { I18n.t('invoice.controller.tested') => [0,0,type.test_price], I18n.t('invoice.controller.repaired') => [0,0,type.repair_price], I18n.t('invoice.controller.scrapped') => [0,0,type.scrap_price], I18n.t('invoice.controller.skipped') => [0,0,0] }

      Entry.where(invoice_id: @invoice.id, type_id: type.id).each do |entry|

        if entry.scrap == 1
          s = 2
          p = type.scrap_price
        elsif entry.repaired == 1
          s = 1
          p = type.repair_price
        elsif entry.test == 1
          s = 0
          p = type.test_price
        else
          s = 3
          p = 0
        end

        price_total[@statuses[s]][0] += 1
        price_total[@statuses[s]][1] += p
        price_global_total[@statuses[s]][0] += 1
        price_global_total[@statuses[s]][1] += p
      end

      total_temp = [0,0,-1]
      price_total.each do |key, value|
        total_temp[0] += value[0]
        total_temp[1] += value[1]      
      end
      price_total[t('global.total')] = total_temp
      @price_type_total[type.brand_type] = price_total
    end

    total_temp = [0,0,-1]
    @price_type_total.each do |key, value|
      total_temp[0] += value[t('global.total')][0]
      total_temp[1] += value[t('global.total')][1]
    end
    price_global_total[t('global.total')] = total_temp
    @price_type_total[I18n.t('global.total')] = price_global_total

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
    params[:invoice][:company_id] = params[:company_id]
    @invoice = Invoice.new(params[:invoice].permit(:company_id))

    entries = Array.new

    non_existing = Array.new
    already_sent = Array.new
    wrong_comp = Array.new
    items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      app = Appliance.where(abb: num[1]).take
      types = Type.where(appliance_id: app.id).ids
      entry = Entry.where(company_id: params[:company_id], number: num[2..-1], type_id: types).take
      entries.append(entry)
      if entry.nil?
      	non_existing.push(num)
      elsif entry.sent.to_i == 1
      	already_sent.push(num)
      elsif entry.company_id != params[:company_id].to_i
        wrong_comp.push(num)
      end
    end

    if non_existing.length == 0 and already_sent.length == 0 and wrong_comp.length == 0 and @invoice.save
      entries.each do |entry|
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
        flash["alert #{item}"] = "#{item} #{I18n.t('invoice.controller.wrong_company')} #{Company.find(params[:company_id]).title}!"
      end
      render 'new'
    end
  end
end
