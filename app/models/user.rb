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

  # Add any company that exists here as a supplier
  def supplier?
    !self.nil? && !self.id.nil? &&
    !self.staff? && !self.guest? && !(self.has_role? :user) &&
    Role.where(name: self.roles.first.name).count != 0
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
      MailJob.new.async.perform(1, {'name' => self.name, 'email' => self.email})
    end

    def notify_admin
      MailJob.new.async.perform(2, {'email' => self.email})
    end
end
