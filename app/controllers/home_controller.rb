class HomeController < ApplicationController
  def index
  end

  def report
  end

  def send_report
  	Mailer.send_error_report(current_user, params[:home][:message]).deliver!
  	redirect_to root_path, :notice => "Report sent."
  end
end
