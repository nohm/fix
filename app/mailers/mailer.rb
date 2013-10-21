class Mailer < ActionMailer::Base
  default from: 'noreply@snack.sytes.net'
 
  def send_welcome_message(user)
  	@user = user
  	@url = "http://snack.sytes.net/badger"
    mail(to: user.email, subject: 'Welcome to Badger, ' + user.name)
  end

  def send_new_user_message(user)
  	@user = user
  	@url = "http://snack.sytes.net/badger/users"
    mail(to: ENV["GMAIL_USERNAME"], subject: 'New sign up for Badger')
  end
end