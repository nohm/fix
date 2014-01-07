class Mailer < ActionMailer::Base
  default from: 'noreply@nohm.eu'
 
  def send_welcome_message(user)
  	@user = user
  	@url = "http://nohm.eu/badger"
    mail(to: user.email, subject: 'Welcome to Badger, ' + user.name)
  end

  def send_new_user_message(user)
  	@user = user
  	@url = "http://nohm.eu/badger/users"
    mail(to: ENV["GMAIL_USERNAME"], subject: 'New sign up for Badger')
  end

  def send_error_report(user, message)
    @user = user
    @message = message
    mail(to: ENV["GMAIL_USERNAME"], subject: 'Badger: Error report')
  end


  def send_role_update(user)
    @role = user.roles.first.name
    @url = "http://nohm.eu/badger"
    mail(to: user.email, subject: 'Badger: Role updated')
  end
end