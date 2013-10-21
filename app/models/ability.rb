class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :manager
      can :see_data, :all
      can :manage, [Entry, Invoice, Attachment, Appliance]
    elsif user.has_role? :technician
      can :see_data, :all
      can [:index, :show, :create, :edit], [Entry, Invoice, Attachment]
      cannot :manage, [User, Appliance]

    elsif user.has_role? :vitel or user.roles.first.name == 'maxi-outlet' or user.has_role? :tronex or user.has_role? :ahead
      can :see_data, :all
      can :index, [Entry, Invoice, Attachment] 
      can :show, [Entry, Invoice, Attachment]

    elsif user.has_role? :user
      cannot :see_data, :all
      cannot :manage, :all
    end

    can :destroy, User
    can :create, User
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
