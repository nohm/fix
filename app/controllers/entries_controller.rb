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
          type = Type.where(appliance_id: Appliance.where(abb: params[:searchnum][1].upcase).first.id).first
          entries = Entry.includes(:attachments).where('type_id = ? AND number = ? AND company_id = ?', type.id, params[:searchnum][2..-1], params[:company_id])
          redirect_to company_entry_path(params[:company_id], entries.first.id)
        rescue
          redirect_to company_entries_path(params[:company_id]), :alert => "Entry not found with number #{params[:searchnum]}."
        end
      elsif params[:searchbrand]
        types = Type.where('brand ILIKE ?', params[:searchbrand]).ids
        @entries = Entry.includes(:attachments,:type,:company,:classifications).where(type_id: types, company_id: params[:company_id]).order('id ASC')
      elsif params[:searchtype]
        types = Type.where('typenum ILIKE ?', params[:searchtype]).ids
        @entries = Entry.includes(:attachments,:type,:company,:classifications).where(type_id: types, company_id: params[:company_id]).order('id ASC')
      elsif params[:searchserial]
        @entries = Entry.includes(:attachments,:type,:company,:classifications).where('serialnum ILIKE ? AND company_id = ?', params[:searchserial], params[:company_id]).order('id ASC')
      elsif params[:searchstatus]
        @entries = Entry.includes(:attachments,:type,:company,:classifications).where(status: params[:searchstatus], company_id: params[:company_id]).order('id ASC')
      else
        @entries = Entry.includes(:attachments,:type,:company,:classifications).where(company_id: params[:company_id]).order('id ASC').page(params[:page]).per(25)
        @pagination = true
      end

      @company = Company.find(params[:company_id])
      @statuses = Entry.select("DISTINCT status").map(&:status).sort!
    else
      redirect_to root_path, :alert => I18n.t('global.unauthorized')
    end
  end

  def new
    authorize! :new, Entry, :message => I18n.t('global.unauthorized')

    @entry = Entry.new
    @type_names = Array.new
    Type.where(company_id: params[:company_id]).pluck(:brand, :typenum, :id).each do |type|
      @type_names.append(["#{type[0]} #{type[1]}", type[2]])
    end
    @class_names = Classifications.pluck(:name, :id)
  end

  def show
    authorize! :show, Entry, :message => I18n.t('global.unauthorized')
    @entry = Entry.includes(:attachments).find(params[:id])
  end

  def zip
    authorize! :zip, Entry, :message => I18n.t('global.unauthorized')

    entry = Entry.includes(:attachments).find(params[:id])
    temp_file  = Tempfile.new("#{entry.id}-#{entry.number}")
    entry.zip_images(temp_file)
    send_file temp_file.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{entry.company.abb + entry.type.appliance.abb + entry.number.to_s}-#{I18n.t('entry.controller.images')}.zip"
    temp_file.close
  end

  def sticker
    authorize! :sticker, Entry, :message => I18n.t('global.unauthorized')
    entry = Entry.find(params[:id])
    @number = entry.company.abb + entry.type.appliance.abb + entry.number.to_s
    @barcode = entry.get_barcode(@number).html_safe
    render 'sticker', :layout => false
  end

  def ticket
    authorize! :ticket, Entry, :message => I18n.t('global.unauthorized')
    @entry = Entry.find(params[:id])
    @number = @entry.company.abb + @entry.type.appliance.abb + @entry.number.to_s
    @barcode = @entry.get_barcode(@number).html_safe
    render 'ticket', :layout => false
  end

  def edit
    authorize! :edit, Entry, :message => I18n.t('global.unauthorized')

    @entry = Entry.find(params[:id])
    @type_names = Array.new
    Type.where(company_id: @entry.company_id).pluck(:brand, :typenum, :id).each do |type|
      @type_names.append(["#{type[0]} #{type[1]}", type[2]])
    end
    @class_names = Classifications.pluck(:name, :id)
  end

  def update
    authorize! :update, Entry, :message => I18n.t('global.unauthorized')

    params[:entry][:company_id] = params[:company_id]

    @entry = Entry.find(params[:id])

    if @entry.type.appliance_id == Type.find(params[:entry][:type_id]).appliance_id
      params[:entry][:number] = @entry.number
    else
      highest_id = 0
      Type.where(company_id: params[:company_id]).each do |type|
        entries = Entry.where(type_id: type.id).order('id ASC')
        if entries.length != 0
          if entries.last.number.to_i > highest_id
            highest_id = entries.last.number.to_i
          end
        end
      end

      params[:entry][:number] = highest_id + 1
    end
      
    if @entry.update(params[:entry].permit(:appliance_id,:number,:type_id,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:classifications_id,:note,:status,:company_id))
      redirect_to company_entries_path(:company => params[:company_id], :page => session[:page]), :notice => I18n.t('entry.controller.updated')
    else
      @type_names = Array.new
      Type.pluck(:brand, :typenum, :id).each do |type|
        @type_names.append(["#{type[0]} #{type[1]}", type[2]])
      end
      @class_names = Classifications.pluck(:name, :id)
      render 'edit'
    end
  end
 
  def create
    authorize! :create, Entry, :message => I18n.t('global.unauthorized')

    params[:entry][:company_id] = params[:company_id]

    highest_id = 0
    Type.where(company_id: params[:company_id]).each do |type|
      entries = Entry.where(type_id: type.id).order('id ASC')
      if entries.length != 0
        if entries.last.number.to_i > highest_id
          highest_id = entries.last.number.to_i
        end
      end
    end

    params[:entry][:number] = highest_id + 1

    @entry = Entry.new(params[:entry].permit(:appliance_id,:number,:type_id,:serialnum,:defect,:repair,:ordered,:testera,:testerb,:test,:repaired,:ready,:scrap,:accessoires,:sent,:classifications_id,:note,:status,:company_id))
    
    if @entry.save
      redirect_to company_entries_path(:company => params[:company_id], :page => Entry.where(company_id: params[:company_id]).page(params[:page]).per(25).total_pages), :notice => I18n.t('entry.controller.added')
    else
      @type_names = Array.new
      Type.pluck(:brand, :typenum, :id).each do |type|
        @type_names.append(["#{type[0]} #{type[1]}", type[2]])
      end
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
