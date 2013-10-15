class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
  end

  def show
    @invoice = Invoice.find(params[:id])
    @entries = Array.new
  	@invoice.items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      @app = Appliance.find_by(abb: num[0])
      @entry = Entry.where(number: num[1..-1], appliance_id: @app.id).take
      @entries.push(@entry)
    end
    @appliances = Appliance.all
  end

  def index
  	if current_user.has_role? :technician or current_user.has_role? :manager or current_user.has_role? :admin or current_user.roles.first.name == params[:company]
      @invoices = Invoice.where(company: params[:company]).page(params[:page]).per(25)
    end
  end

  def destroy
    invoice = Invoice.find(params[:id])
    invoice.items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      app = Appliance.find_by(abb: num[0])
      entry = Entry.where(number: num[1..-1], appliance_id: app.id).take
      entry.update_attribute(:sent, 0)
      entry.update_attribute(:sent_date, "")
    end
    invoice.destroy
    redirect_to invoices_path(company: params[:company]), :notice => "Invoice deleted."
  end

  def create
    @invoice = Invoice.new(params[:invoice].permit(:items,:company))

 	  non_existing = Array.new
 	  already_sent = Array.new
    wrong_comp = Array.new
 	  @invoice.items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      @app = Appliance.where(abb: num[0]).take
      @entry = Entry.where(number: num[1..-1], appliance_id: @app.id).take
      if @entry.nil?
      	non_existing.push(num)
      elsif @entry.sent.to_i == 1
      	already_sent.push(num)
      elsif @entry.company != params[:company]
        wrong_comp.push(num)
      else
      	@entry.update_attribute(:sent, 1)
        @entry.update_attribute(:sent_date, DateTime.now)
      end
    end

    if non_existing.length == 0 and already_sent.length == 0 and @invoice.save
      redirect_to invoices_path(company: params[:invoice][:company]), :notice => "Invoice added."
    else
      non_existing.each do |item|
      	flash["alert#{item}"] = "#{item} doesn't exist!"
      end
      already_sent.each do |item|
      	flash["alert#{item}"] = "#{item} was already sent!"
      end
      wrong_comp.each do |item|
        flash["alert#{item}"] = "#{item} doesn't belong to #{parms[:company]}!"
      end
      render 'new'
    end
  end
end
