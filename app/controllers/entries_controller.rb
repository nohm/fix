class EntriesController < ApplicationController
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


  def index
    authorize! :index, Entry, :message => I18n.t('global.unauthorized')

    unless params[:page].nil?
      session[:page] = params[:page]
    end

    if can? :index, Entry or current_user.roles.first.name == Company.find(params[:company_id].short)
      if params[:searchnum]
        begin
          @entries = Entry.includes(:attachments).where('appliance_id = ? AND number = ? AND company_id = ?', Appliance.where(abb: params[:searchnum][1].upcase).first.id, params[:searchnum][2..-1], params[:company_id])
          redirect_to company_entry_path(params[:company_id], @entries.first.id)
        rescue
          redirect_to company_entries_path(params[:company_id]), :alert => "Entry not found with number #{params[:searchnum]}."
        end
      elsif params[:searchbrand]
        @entries = Entry.includes(:attachments).where('brand ILIKE ? AND company_id = ?', params[:searchbrand], params[:company_id]).order('id ASC')
      elsif params[:searchtype]
        @entries = Entry.includes(:attachments).where('typenum ILIKE ? AND company_id = ?', params[:searchtype], params[:company_id]).order('id ASC')
      elsif params[:searchserial]
        @entries = Entry.includes(:attachments).where('serialnum ILIKE ? AND company_id = ?', params[:searchserial], params[:company_id]).order('id ASC')
      elsif params[:searchstatus]
        @entries = Entry.includes(:attachments).where(status: params[:searchstatus], company_id: params[:company_id]).order('id ASC')
      else
        @entries = Entry.includes(:attachments).where(company_id: params[:company_id]).order('id ASC').page(params[:page]).per(25)
        @pagination = true
      end
      @company = Company.find(params[:company_id])
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
    @entry = Entry.includes(:attachments).find(params[:id])
    @company = Company.find(@entry.company_id)
    @appliance = Appliance.find(@entry.appliance_id)
    @classification = Classifications.find(@entry.class_id)
    unless @entry.invoice_id.nil?
      @invoice = Invoice.find(@entry.invoice_id)
    end
  end

  def zip
    authorize! :zip, Entry, :message => I18n.t('global.unauthorized')

    entry = Entry.includes(:attachments).find(params[:id])
    appliance = Appliance.find(entry.appliance_id)
    company = Company.find(entry.company_id)
    temp_file  = Tempfile.new("#{entry.id}-#{entry.number}")
    entry.zip_images(temp_file)
    send_file temp_file.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{company.abb + appliance.abb + entry.number.to_s}-#{I18n.t('entry.controller.images')}.zip"
    temp_file.close
  end

  def sticker
    authorize! :sticker, Entry, :message => I18n.t('global.unauthorized')
    entry = Entry.find(params[:id])
    appliance = Appliance.find(entry.appliance_id)
    company = Company.find(entry.company_id)
    @number = company.abb + appliance.abb + entry.number.to_s
    @barcode = entry.get_barcode(@number).html_safe
    render 'sticker', :layout => false
  end

  def ticket
    authorize! :ticket, Entry, :message => I18n.t('global.unauthorized')
    @entry = Entry.find(params[:id])
    @appliance = Appliance.find(@entry.appliance_id)
    company = Company.find(@entry.company_id)
    @number = company.abb + @appliance.abb + @entry.number.to_s
    @barcode = @entry.get_barcode(@number).html_safe
    render 'ticket', :layout => false
  end

  def entryhistory
    authorize! :entryhistory, Entry, :message => I18n.t('global.unauthorized')

    @entry = Entry.find(params[:id])
    @appliance = Appliance.find(@entry.appliance_id)
    @company = Company.find(@entry.company_id)
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

    params[:entry][:company_id] = params[:company_id]

    @entry = Entry.find(params[:id])

    if @entry.appliance_id == params[:entry][:appliance_id].to_i
      params[:entry][:number] = @entry.number
    else
      entries = Entry.where(appliance_id: params[:entry][:appliance_id]).order('id ASC')
      if entries.length == 0
        params[:entry][:number] = 1
      else 
        params[:entry][:number] = entries.last.number.to_i + 1
      end
    end
      
    if @entry.update(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:class_id,:note,:status,:company_id))
      redirect_to company_entries_path(:company => params[:company_id], :page => session[:page]), :notice => I18n.t('entry.controller.updated')
    else
      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
      render 'edit'
    end
  end
 
  def create
    authorize! :create, Entry, :message => I18n.t('global.unauthorized')

    params[:entry][:company_id] = params[:company_id]

    entries = Entry.where(appliance_id: params[:entry][:appliance_id]).order('id ASC')
    if entries.length == 0
      params[:entry][:number] = 1
    else 
      params[:entry][:number] = entries.last.number.to_i + 1
    end

    @entry = Entry.new(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:class_id,:note,:status,:company_id))
    
    if @entry.save
      redirect_to company_entries_path(:company => params[:company_id], :page => Entry.where(company_id: params[:company_id]).page(params[:page]).per(25).total_pages), :notice => I18n.t('entry.controller.added')
    else
      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
      render 'new'
    end
  end

  def destroy
    authorize! :destroy, Entry, :message => I18n.t('global.unauthorized')

    entry = Entry.find(params[:id])
    entry.destroy
    redirect_to company_entries_path(:company => params[:company_id]), :notice => I18n.t('entry.controller.deleted')
  end

end
