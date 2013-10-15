class EntriesController < ApplicationController

  def index
    if can? :create, Entry or current_user.roles.first.name == params[:company]
      if params[:searchnum]
        begin
          @entries = Entry.where('appliance_id LIKE ? AND number LIKE ? AND company = ?', Appliance.where(abb: params[:search][0]).first.id, params[:searchnum][1..-1].to_i, params[:company])
          redirect_to entry_path(@entries.first, company: params[:company])
        rescue
          redirect_to entries_path(company: params[:company]), :alert => "Entry not found with number #{params[:searchnum]}."
        end
      elsif params[:searchbrand]
        @entries = Entry.where('brand LIKE ? AND company = ?', params[:searchbrand], params[:company])
      elsif params[:searchtype]
        @entries = Entry.where('typenum LIKE ? AND company = ?', params[:searchtype], params[:company])
      elsif params[:searchserial]
        @entries = Entry.where('serialnum LIKE ? AND company = ?', params[:searchserial], params[:company])
      else
        @entries = Entry.where(company: params[:company]).page(params[:page]).per(25)
        @pagination = true
      end
    else
      redirect_to root_path, :alert => "You\'re not authorized for this"
    end
    @appliances = Appliance.all
  end

  def new
    @entry = Entry.new
    @appliance_names = Appliance.pluck(:name, :id)
  end

  def show
    @entry = Entry.find(params[:id])
    @appliance = Appliance.all[@entry.appliance_id - 1]
  end

  def zip
    @entry = Entry.find(params[:id])
    @appliance = Appliance.all[@entry.appliance_id - 1]
    temp_file  = Tempfile.new("#{@entry.id}-#{@entry.number}")
    @entry.zip_images(temp_file)
    send_file temp_file.path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{@appliance.abb + @entry.number.to_s}-images.zip"
    temp_file.close
  end

  def sticker
    @entry = Entry.find(params[:id])
    @appliance = Appliance.all[@entry.appliance_id - 1]
    render inline: '<div><h1 style="float:left;margin-left:5px;margin-right:5px;margin-top:20px"><%= @appliance.abb + @entry.number.to_s %></h1><p style="float:left"><%= @entry.get_barcode(@appliance.abb + @entry.number.to_s).html_safe %></p></div>'
  end

  def edit
    @entry = Entry.find(params[:id])
    @appliance_names = Appliance.pluck(:name, :id)
  end

  def update
    unless params[:id] == 'all'
      @entry = Entry.find(params[:id])

      unless params[:entry][:sent].to_i == 1 and @entry.sent == 0
        params[:entry][:sent_date] = ""
      else
        params[:entry][:sent_date] = DateTime.now
      end

      if @entry.appliance_id == params[:entry][:appliance_id].to_i
        params[:entry][:number] = @entry.number
      else
        entries = Entry.where(appliance_id: params[:entry][:appliance_id]).order('number')
        if entries.length == 0
          params[:entry][:number] = 1
        else 
          params[:entry][:number] = entries.last.number.to_i + 1
        end
      end
      
      if @entry.update(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:test,:repaired,:ready,:scrap,:accessoires,:sent,:sent_date,:note,:company))
        redirect_to entries_path(company: params[:entry][:company]), :notice => "Entry updated."
      else
        @appliance_names = Appliance.pluck(:name, :id)
        render 'edit', company: params[:invoice][:company]
      end
    else
      update_all(params[:entry][:numbers])
    end
  end
 
  def create
    unless params[:entry][:sent].to_i == 1
      params[:entry][:sent_date] = ""
    else
      params[:entry][:sent_date] = DateTime.now
    end

    entries = Entry.where(appliance_id: params[:entry][:appliance_id]).order('number')
    if entries.length == 0
      params[:entry][:number] = 1
    else 
      params[:entry][:number] = entries.last.number.to_i + 1
    end

    @entry = Entry.new(params[:entry].permit(:appliance_id,:number,:brand,:typenum,:serialnum,:test,:repaired,:ready,:scrap,:accessoires,:sent,:sent_date,:note,:company))
    
    if @entry.save
      redirect_to entries_path(company: params[:entry][:company]), :notice => "Entry added."
    else
      @appliance_names = Appliance.pluck(:name, :id)
      render 'new', company: params[:invoice][:company]
    end
  end

  def destroy
    entry = Entry.find(params[:id])
    company = entry.company
    entry.destroy
    redirect_to entries_path(company: company), :notice => "Entry deleted."
  end

end
