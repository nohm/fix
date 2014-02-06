class Mailer < ActionMailer::Base
  default from: 'administrator@nohm.eu'
 
  def send_welcome_message(name, email)
    @name = name
    @email = email
    @url = "#{ENV['BASE_URL']}/badger"
    mail(to: email, subject: t('mailer.base.welcome') + name)
  end

  def send_new_user_message(email)
    @email = email
    @url = "#{ENV['BASE_URL']}/badger/users"
    mail(to: ENV["GMAIL_USERNAME"], subject: t('mailer.base.new_user'))
  end

  def send_error_report(email, message)
    @email = email
    @message = message
    mail(to: ENV["GMAIL_USERNAME"], subject: t('mailer.base.error_report'))
  end

  def send_role_update(role)
    @role = role
    @url = "#{ENV['BASE_URL']}/badger"
    mail(to: email, subject: t('mailer.base.role_update'))
  end
end
