class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :default_role, :welcome_mail, :notify_admin

  private
    def default_role
      if self.roles.length == 0
        self.roles << Role.where(:name => 'user').first
      end
    end

    def welcome_mail
      Mailer.send_welcome_message(self).deliver!
    end

    def notify_admin
      Mailer.send_new_user_message(self).deliver!
    end
end
