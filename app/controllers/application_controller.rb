class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  before_filter :role_list, :is_landing, :locale_list

  def role_list
  	unless current_user.nil?
	    if current_user.has_role? :technician or current_user.has_role? :manager or current_user.has_role? :admin
	    	@roles = Role.all
	    else
	    	@roles = Role.where(name: current_user.roles.first.name)
	    end
	  end
  end

  def is_landing
    unless user_signed_in?
      @landing = 'landing'
    end
  end

  def locale_list
    @locales = {'English' => 'en', 'Nederlands' => 'nl', 'Deutsch' => 'de'}
  end

  before_action :set_locale

  def set_locale
    unless user_signed_in?
      I18n.locale = params[:locale] || I18n.default_locale
    else
      I18n.locale = current_user.language || I18n.default_locale
    end
  end
end
