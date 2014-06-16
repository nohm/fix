class HomeController < ApplicationController
  def index
    unless current_user.nil? or current_user.has_role? :user
      if current_user.staff?
        @companies = Company.all.includes(:entries,:invoices,:shipments).order('id ASC')
        @panelclass = 'col-xs-6 col-sm-3'
      elsif current_user.supplier?
        @companies = Company.includes(:entries,:invoices,:shipments).where(short: current_user.roles.first.name)
        @panelclass = 'col-md-4 col-md-offset-4'
      end
      @simple_stats = Array.new
      @companies.each_with_index do |company, index|
        @simple_stats[index] = Array.new
        @simple_stats[index][0] = company.entries.length
        @simple_stats[index][1] = company.invoices.length
        @simple_stats[index][2] = company.shipments.length
      end
    end
  end

  # Batch function for updating multiple entries
  def batch
    authorize! :update, Entry, :message => I18n.t('global.unauthorized')

    @appliance_names = Appliance.pluck(:name, :id)
    @class_names = Classifications.pluck(:name, :id)
    @type_names = Array.new
    Apptype.pluck(:brand, :typenum, :id).each do |type|
      @type_names.append(["#{type[0]} #{type[1]}", type[2]])
    end
  end

  # The post function that catches and handles batch updating the entries
  def batch_update
    authorize! :update, Entry, :message => I18n.t('global.unauthorized')

    items = params[:entry][:ordernumbers]

    entries = Array.new

    non_existing = Array.new
    wrong_comp = Array.new
    items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      entry = Entry.find_number(num)
      if entry.nil?
        non_existing.push(num)
      elsif entry.company_id != params[:company_id].to_i
        wrong_comp.push(num)
      else
        entries.append(entry.id)
      end
    end

    if non_existing.length == 0 and wrong_comp.length == 0
      params[:entry].each do |key, value|
        unless key == 'ordernumbers' or key == 'enable'
          if params[:entry][:enable]['entry_' + key] == '1'
            Entry.update_all({key => params[:entry][key]}, {:id => entries})
          end
        end
      end
      redirect_to root_path, :notice => "#{I18n.t('home.controller.success')} #{items.lines.length} #{I18n.t('home.controller.success_end')}"
    else
      non_existing.each do |item|
        flash["alert #{item}"] = "#{item} #{I18n.t('home.controller.error_exist')}"
      end
      wrong_comp.each do |item|
        flash["alert #{item}"] = "#{item} #{I18n.t('home.controller.error_wrong')} #{Company.find(params[:company_id]).title}!"
      end

      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
      @type_names = Array.new
      Apptype.pluck(:brand, :typenum, :id).each do |type|
        @type_names.append(["#{type[0]} #{type[1]}", type[2]])
      end
      render 'batch'
    end
  end

  def report
  end

  def send_report
  	MailJob.new.async.perform(3, {'email' => current_user.email, 'message' => params[:home][:message]})
  	redirect_to root_path, :notice => "Report sent."
  end
end
