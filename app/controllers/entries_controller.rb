class EntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
          Entry.where(company: session[:company]).each do |entry|
        status = entry.get_status
        unless @statuses.include? status
          @statuses.append status
        end
        entry.update_attribute(:status, entry.get_status)
      end

    authorize! :index, Entry, :message => 'You\'re not authorized for this.'

    unless params[:company].nil?
      session[:company] = params[:company]
    end
    unless params[:page].nil?
      session[:page] = params[:page]
    end

    if !session[:company].nil? and (can? :index, Entry or current_user.roles.first.name == session[:company])
      if params[:searchnum]
        begin
          @entries = Entry.where('appliance_id = ? AND number = ? AND company = ?', Appliance.where(abb: params[:searchnum][1].upcase).first.id, params[:searchnum][2..-1].to_i, session[:company])
          redirect_to entry_path(@entries.first.id)
        rescue
          redirect_to entries_path, :alert => "Entry not found with number #{params[:searchnum]}."
        end
      elsif params[:searchbrand]
        @entries = Entry.where('brand LIKE ? AND company = ?', params[:searchbrand], session[:company])
      elsif params[:searchtype]
        @entries = Entry.where('typenum LIKE ? AND company = ?', params[:searchtype], session[:company])
      elsif params[:searchserial]
        @entries = Entry.where('serialnum LIKE ? AND company = ?', params[:searchserial], session[:company])
      elsif params[:searchstatus]
        @entries = Entry.where(status: params[:searchstatus], company: session[:company])
      else
        @entries = Entry.where(company: session[:company]).page(params[:page]).per(25)
        @pagination = true
      end
      @appliances = Appliance.all
      @statuses = Entry.select("DISTINCT status").map(&:status)
    else
      redirect_to root_path, :alert => "You\'re not authorized for this."
    end
  end

  def new
    authorize! :new, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.new
    @appliance_names = Appliance.pluck(:name, :id)
    @class_names = Classifications.pluck(:name, :id)
  end

  def show
    authorize! :show, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.find(params[:id])
    @appliance = Appliance.where(id: @entry.appliance_id).first
    @classification = Classifications.where(id: @entry.class_id).first
    @invoice = Invoice.where(id: @entry.invoice_id).first
  end

  def zip
    authorize! :zip, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.find(params[:id])
    @appliance = Appliance.where(id: @entry.appliance_id).first
    temp_file  = Tempfile.new("#{@entry.id}-#{@entry.number}")
    @entry.zip_images(temp_file)
    send_file temp_file.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@entry.company[0].upcase! + @appliance.abb + @entry.number.to_s}-images.zip"
    temp_file.close
  end

  def sticker
    authorize! :sticker, Entry, :message => 'You\'re not authorized for this.'

    entry = Entry.find(params[:id])
    appliance = Appliance.where(id: entry.appliance_id).first
    @abb = entry.company[0].upcase! + appliance.abb
    @number = entry.number.to_s
    @barcode = entry.get_barcode(@abb + @number).html_safe
    render 'sticker', :layout => false
  end

  def entryhistory
    authorize! :entryhistory, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.find(params[:id])
    @appliance = Appliance.where(id: @entry.appliance_id).first
    @history = History.where(entry_id: params[:id])
    @users = User.all
  end

  def edit
    authorize! :edit, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.find(params[:id])
    @appliance_names = Appliance.pluck(:name, :id)
    @class_names = Classifications.pluck(:name, :id)
  end

  def update
    authorize! :update, Entry, :message => 'You\'re not authorized for this.'

    if session[:company].nil?
      redirect_to root_path, :notice => 'Please re-open the entry index'
    end

    @entry = Entry.find(params[:id])

    if @entry.appliance_id == params[:entry][:appliance_id].to_i
      params[:entry][:number] = @entry.number
    else
      entries = Entry.where(appliance_id: params[:entry][:appliance_id])
      if entries.length == 0
        params[:entry][:number] = 1
      else 
        params[:entry][:number] = entries.last.number.to_i + 1
      end
    end

    params[:entry][:status] = @entry.get_status
      
    if @entry.update(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:class_id,:note,:company,:status))
      redirect_to entries_path(:page => session[:page]), :notice => "Entry updated."
    else
      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
      render 'edit'
    end

    History.new({:entry_id => @entry.id, :user_id => current_user.id, :action => 'update'}).save
  end
 
  def create
    authorize! :create, Entry, :message => 'You\'re not authorized for this.'

    if session[:company].nil?
      redirect_to root_path, :notice => 'Please re-open the entry index'
    end

    entries = Entry.where(appliance_id: params[:entry][:appliance_id])
    if entries.length == 0
      params[:entry][:number] = 1
    else 
      params[:entry][:number] = entries.last.number.to_i + 1
    end

    params[:entry][:status] = @entry.get_status

    @entry = Entry.new(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:class_id,:note,:company,:status))
    
    if @entry.save
      redirect_to entries_path(:page => Entry.where(company: session[:company]).page(params[:page]).per(25).total_pages), :notice => "Entry added."
    else
      @appliance_names = Appliance.pluck(:name, :id)
    @class_names = Classifications.pluck(:name, :id)
      render 'new'
    end

    History.new({:entry_id => @entry.id, :user_id => current_user.id, :action => 'create'}).save
  end

  def destroy
    authorize! :destroy, Entry, :message => 'You\'re not authorized for this.'

    entry = Entry.find(params[:id])
    entry.destroy
    redirect_to entries_path, :notice => "Entry deleted."

    History.new({:entry_id => 0, :user_id => current_user.id, :action => 'destroy'}).save
  end

end
