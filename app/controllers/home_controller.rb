class HomeController < ApplicationController
  def index
    unless current_user.nil?
      if current_user.staff?
        @companies = Company.all.order('id ASC')
      elsif current_user.supplier?
        @companies = Company.where(short: current_user.roles.first.name)
      end
      @simple_stats = Array.new
      @companies.each_with_index do |company, index|
        @simple_stats[index] = Array.new
        @simple_stats[index][0] = company.entries.length
        @simple_stats[index][1] = company.invoices.length
      end
    end
  end

  # Batch function for updating multiple entries
  def batch
    authorize! :update, Entry, :message => I18n.t('global.unauthorized')

    @appliance_names = Appliance.pluck(:name, :id)
    @class_names = Classifications.pluck(:name, :id)
  end

  # The post function that catches and handles batch updating the entries
  def batch_update
    authorize! :update, Entry, :message => I18n.t('global.unauthorized')

    items = params[:entry][:ordernumbers]

    non_existing = Array.new
    wrong_comp = Array.new
    items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      app = Appliance.where(abb: num[1]).take
      entry = Entry.where(company_id: params[:company_id], number: num[2..-1], appliance_id: app.id).take
      if entry.nil?
        non_existing.push(num)
      elsif entry.company_id != params[:company_id]
        wrong_comp.push(num)
      end
    end

    if non_existing.length == 0 and wrong_comp.length == 0
      items.lines do |line|
        num = line.tr("\n","").tr("\r","")
        app = Appliance.where(abb: num[1]).take
        entry = Entry.where(company_id: params[:company_id], number: num[2..-1], appliance_id: app.id).take
        params[:entry].each do |key, value|
          unless key == 'ordernumbers' or key == 'enable'
            if params[:entry][:enable]['entry_' + key] == '1'
              entry.update_attribute(key, params[:entry][key])
            end
          end
        end
      end
      redirect_to root_path, :notice => "#{I18n.t('home.controller.success')} #{items.lines.length} #{I18n.t('home.controller.success_end')}"
    else
      non_existing.each do |item|
        flash["alert #{item}"] = "#{item} #{I18n.t('home.controller.error_exist')}"
      end
      wrong_comp.each do |item|
        flash["alert #{item}"] = "#{item} #{I18n.t('home.controller.error_wrong')} #{Company.find(params[:company_id].title)}!"
      end

      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
      render 'batch'
    end
  end

  def report
  end

  def send_report
  	Mailer.send_error_report(current_user, params[:home][:message]).deliver!
  	redirect_to root_path, :notice => "Report sent."
  end
end
