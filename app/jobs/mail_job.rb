class MailJob
  include SuckerPunch::Job

  def perform(what, data)
    case what
    when 1 # New user signup towards user
    	Mailer.send_welcome_message(data['name'], data['email']).deliver!
    when 2 # New user signup towards admin
    	Mailer.send_new_user_message(data['email']).deliver!
    when 3 # Error report towards admin
    	Mailer.send_error_report(data['email'], data['message']).deliver!
    when 4 # Role update towards user
    	Mailer.send_role_update(data['role'], data['email']).deliver!
    when 5 # Stock shortage towards supplier
      Mailer.send_stock_request(data['type'], data['stock'], data['email']).deliver!
    end
  end
end
