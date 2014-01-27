class EntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, Entry, :message => I18n.t('global.unauthorized')

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
      @statuses = Entry.select("DISTINCT status").map(&:status).sort!
    else
      redirect_to root_path, :alert => I18n.t('global.unauthorized')
    end
  end

  def new
    authorize! :new, Entry, :message => I18n.t('global.unauthorized')

    @entry = Entry.new
    @appliance_names = Appliance.pluck(:name, :id)
    @class_names = Classifications.pluck(:name, :id)
  end

  def show
    authorize! :show, Entry, :message => I18n.t('global.unauthorized')
    @entry = Entry.find(params[:id])
    @appliance = Appliance.find(@entry.appliance_id)
    @classification = Classifications.find(@entry.class_id)
    unless @entry.invoice_id.nil?
      @invoice = Invoice.find(@entry.invoice_id)
    end
  end

  def zip
    authorize! :zip, Entry, :message => I18n.t('global.unauthorized')

    @entry = Entry.find(params[:id])
    @appliance = Appliance.find(@entry.appliance_id)
    temp_file  = Tempfile.new("#{@entry.id}-#{@entry.number}")
    @entry.zip_images(temp_file)
    send_file temp_file.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@entry.company[0].upcase! + @appliance.abb + @entry.number.to_s}-#{I18n.t('entry.controller.images')}.zip"
    temp_file.close
  end

  def sticker
    authorize! :sticker, Entry, :message => I18n.t('global.unauthorized')
    entry = Entry.find(params[:id])
    appliance = Appliance.find(entry.appliance_id)
    @abb = entry.company[0].upcase! + appliance.abb
    @number = entry.number.to_s
    @barcode = entry.get_barcode(@abb + @number).html_safe
    render 'sticker', :layout => false
  end

  def ticket
    authorize! :ticket, Entry, :message => I18n.t('global.unauthorized')
    @entry = Entry.find(params[:id])
    @appliance = Appliance.find(@entry.appliance_id)
    @number = @entry.company[0].upcase! + @appliance.abb + @entry.number.to_s
    @barcode = @entry.get_barcode(@number).html_safe
    render 'ticket', :layout => false
  end

  def entryhistory
    authorize! :entryhistory, Entry, :message => I18n.t('global.unauthorized')

    @entry = Entry.find(params[:id])
    @appliance = Appliance.find(@entry.appliance_id)
    @history = History.where(entry_id: params[:id])
    @users = User.all
  end

  def edit
    authorize! :edit, Entry, :message => I18n.t('global.unauthorized')

    @entry = Entry.find(params[:id])
    @appliance_names = Appliance.pluck(:name, :id)
    @class_names = Classifications.pluck(:name, :id)
  end

  def update
    authorize! :update, Entry, :message => I18n.t('global.unauthorized')

    if session[:company].nil?
      redirect_to root_path, :notice => I18n.t('global.no_company')
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
      
    if @entry.update(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:class_id,:note,:company,:status))
      redirect_to entries_path(:page => session[:page]), :notice => I18n.t('entry.controller.updated')
    else
      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
      render 'edit'
    end

    History.new({:entry_id => @entry.id, :user_id => current_user.id, :action => 'update'}).save
  end
 
  def create
    authorize! :create, Entry, :message => I18n.t('global.unauthorized')

    if session[:company].nil?
      redirect_to root_path, :notice => I18n.t('global.no_company')
    end

    entries = Entry.where(appliance_id: params[:entry][:appliance_id])
    if entries.length == 0
      params[:entry][:number] = 1
    else 
      params[:entry][:number] = entries.last.number.to_i + 1
    end

    @entry = Entry.new(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:class_id,:note,:company,:status))
    
    if @entry.save
      redirect_to entries_path(:page => Entry.where(company: session[:company]).page(params[:page]).per(25).total_pages), :notice => I18n.t('entry.controller.added')
    else
      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
      render 'new'
    end

    History.new({:entry_id => @entry.id, :user_id => current_user.id, :action => 'create'}).save
  end

  def destroy
    authorize! :destroy, Entry, :message => I18n.t('global.unauthorized')

    entry = Entry.find(params[:id])
    entry.destroy
    redirect_to entries_path, :notice => I18n.t('entry.controller.deleted')

    History.new({:entry_id => 0, :user_id => current_user.id, :action => 'destroy'}).save
  end

end
