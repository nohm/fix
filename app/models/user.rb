class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def admin?
    self.has_role? :admin
  end

  def manager?
    self.admin? or self.has_role? :manager
  end

  def staff?
    self.manager? or self.has_role? :technician
  end

  def supplier?
    self.has_role? :vitel or self..roles.first.name == "maxi-outlet" or self.has_role? :tronex or self.has_role? :ahead
  end

  def guest?
    self.has_role? :guest
  end

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
