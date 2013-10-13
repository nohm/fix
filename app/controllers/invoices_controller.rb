class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
  end

  def show
    @invoice = Invoice.find(params[:id])
    @entries = Array.new
  	@invoice.items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      @entry = Entry.find_by(number: num)
      @entries.push(@entry)
    end
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
      entry = Entry.find_by(number: num)
      entry.update_attribute(:sent, 0)
      entry.update_attribute(:sent_date, "")
    end
    invoice.destroy
    redirect_to invoices_path(company: params[:invoice][:company]), :notice => "Invoice deleted."
  end

  def create
    @invoice = Invoice.new(params[:invoice].permit(:items,:company))

 	  non_existing = Array.new
 	  already_sent = Array.new
 	  @invoice.items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      @entry = Entry.find_by(number: num)
      if @entry.nil?
      	non_existing.push(num)
      elsif @entry.sent.to_i == 1
      	already_sent.push(num)
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
      render 'new'
    end
  end
end
