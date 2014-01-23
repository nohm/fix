class HomeController < ApplicationController
  def index
   session[:company] = nil
  end

  # Batch function for updating multiple entries
  def batch
    unless params[:company].nil?
      session[:company] = params[:company]
    end

    if !session[:company].nil?
      @appliance_names = Appliance.pluck(:name, :id)
      @class_names = Classifications.pluck(:name, :id)
    else
      redirect_to root_path, :alert => I18n.t('global.unauthorized')
    end
  end

  # The post function that catches and handles batch updating the entries
  def batch_update
    items = params[:entry][:ordernumbers]

    non_existing = Array.new
    wrong_comp = Array.new
    items.lines do |line|
      num = line.tr("\n","").tr("\r","")
      app = Appliance.where(abb: num[1]).take
      entry = Entry.where(company: session[:company], number: num[2..-1], appliance_id: app.id).take
      if entry.nil?
        non_existing.push(num)
      elsif entry.company != session[:company]
        wrong_comp.push(num)
      end
    end

    if non_existing.length == 0 and wrong_comp.length == 0
      items.lines do |line|
        num = line.tr("\n","").tr("\r","")
        app = Appliance.where(abb: num[1]).take
        entry = Entry.where(company: session[:company], number: num[2..-1], appliance_id: app.id).take
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
        flash["alert #{item}"] = "#{item} #{I18n.t('home.controller.error_wrong')} #{session[:company]}!"
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
