class InvoicesController < ApplicationController
  before_filter :authenticate_user!

  def new
    authorize! :new, Invoice, :message => 'You\'re not authorized for this.'

    @invoice = Invoice.new
  end

  def show
    authorize! :show, Invoice, :message => 'You\'re not authorized for this.'

    @invoice = Invoice.find(params[:id])
    @entries = Entry.where(invoice_id: params[:id])
    @appliances = Appliance.all
    @company_data = eval(ENV["COMPANIES"])[Role.where(name: session[:company]).take.id - 5]
  end

  def index
    authorize! :index, Invoice, :message => 'You\'re not authorized for this.'

    unless params[:company].nil?
      session[:company] = params[:company]
    end
    if !session[:company].nil? and (can? :create, Entry or current_user.roles.first.name == session[:company])
      @invoices = Invoice.where(company: session[:company]).page(params[:page]).per(25)
    else
      redirect_to root_path, :alert => "You\'re not authorized for this"
    end
  end

  def destroy
    authorize! :destroy, Invoice, :message => 'You\'re not authorized for this.'

    entries = Entry.where(invoice_id: params[:id])
    entries.each do |entry|
      entry.update_attribute(:sent, 0)
      entry.update_attribute(:invoice_id, nil)
    end
    invoice.destroy
    redirect_to invoices_path, :notice => "Invoice deleted."
  end

  def create
    authorize! :create, Invoice, :message => 'You\'re not authorized for this.'

    items = params[:invoice][:items]
    params[:invoice][:items] = params[:invoice][:items].lines.length
    @invoice = Invoice.new(params[:invoice].permit(:items, :company))

    non_existing = Array.new
    already_sent = Array.new
    wrong_comp = Array.new
    items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      app = Appliance.where(abb: num[1]).take
      entry = Entry.where(company: session[:company], number: num[2..-1], appliance_id: app.id).take
      if entry.nil?
      	non_existing.push(num)
      elsif entry.sent.to_i == 1
      	already_sent.push(num)
      elsif entry.company != session[:company]
        wrong_comp.push(num)
      end
    end

    if non_existing.length == 0 and already_sent.length == 0 and wrong_comp.length == 0 and @invoice.save
      items.lines do |line|
        num = line.tr("\n","").tr("\r","")
        app = Appliance.where(abb: num[1]).take
        entry = Entry.where(company: session[:company], number: num[2..-1], appliance_id: app.id).take
        entry.update_attribute(:sent, 1)
        entry.update_attribute(:invoice_id, @invoice.id)
      end
      redirect_to invoices_path, :notice => "Invoice added."
    else
      non_existing.each do |item|
      	flash["alert#{item}"] = "#{item} doesn't exist!"
      end
      already_sent.each do |item|
      	flash["alert#{item}"] = "#{item} was already sent!"
      end
      wrong_comp.each do |item|
        flash["alert#{item}"] = "#{item} doesn't belong to #{session[:company]}!"
      end
      render 'new'
    end
  end
end
