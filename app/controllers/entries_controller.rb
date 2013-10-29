class EntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, Entry, :message => 'You\'re not authorized for this.'

    unless params[:company].nil?
      session[:company] = params[:company]
    end
    if !session[:company].nil? and (can? :index, Entry or current_user.roles.first.name == session[:company])
      if params[:searchnum]
        begin
          @entries = Entry.where('appliance_id LIKE ? AND number LIKE ? AND company = ?', Appliance.where(abb: params[:searchnum][1]).first.id, params[:searchnum][2..-1].to_i, session[:company])
          redirect_to entry_path(@entries.first)
        rescue
          redirect_to entries_path, :alert => "Entry not found with number #{params[:searchnum]}."
        end
      elsif params[:searchbrand]
        @entries = Entry.where('brand LIKE ? AND company = ?', params[:searchbrand], session[:company])
      elsif params[:searchtype]
        @entries = Entry.where('typenum LIKE ? AND company = ?', params[:searchtype], session[:company])
      elsif params[:searchserial]
        @entries = Entry.where('serialnum LIKE ? AND company = ?', params[:searchserial], session[:company])
      else
        @entries = Entry.where(company: session[:company]).page(params[:page]).per(25)
        @pagination = true
      end
      @appliances = Appliance.all
    else
      redirect_to root_path, :alert => "You\'re not authorized for this."
    end
  end

  def new
    authorize! :new, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.new
    @appliance_names = Appliance.pluck(:name, :id)
  end

  def show
    authorize! :show, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.find(params[:id])
    @appliance = Appliance.where(id: @entry.appliance_id).first
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
    @number = entry.company[0].upcase! + appliance.abb + entry.number.to_s
    @barcode = entry.get_barcode(@number).html_safe
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
  end

  def update
    authorize! :update, Entry, :message => 'You\'re not authorized for this.'

    @entry = Entry.find(params[:id])

    if params[:entry][:sent].to_i == 1 and @entry.sent == 0
      params[:entry][:sent_date] = DateTime.now
    elsif params[:entry][:sent].to_i == 0 and @entry.sent == 0
      params[:entry][:sent_date] = ""
    end

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
      
    if @entry.update(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:ordered,:test,:repaired,:ready,:scrap,:accessoires,:sent,:sent_date,:note,:company))
      redirect_to entries_path, :notice => "Entry updated."
    else
      @appliance_names = Appliance.pluck(:name, :id)
      render 'edit'
    end

    History.new({:entry_id => @entry.id, :user_id => current_user.id, :action => 'update'}).save
  end
 
  def create
    authorize! :create, Entry, :message => 'You\'re not authorized for this.'

    unless params[:entry][:sent].to_i == 1
      params[:entry][:sent_date] = ""
    else
      params[:entry][:sent_date] = DateTime.now
    end

    entries = Entry.where(appliance_id: params[:entry][:appliance_id])
    if entries.length == 0
      params[:entry][:number] = 1
    else 
      params[:entry][:number] = entries.last.number.to_i + 1
    end

    @entry = Entry.new(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:defect,:ordered,:test,:repaired,:ready,:scrap,:accessoires,:sent,:sent_date,:note,:company))
    
    if @entry.save
      redirect_to entries_path, :notice => "Entry added."
    else
      @appliance_names = Appliance.pluck(:name, :id)
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
