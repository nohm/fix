class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all

    elsif user.has_role? :manager
      can :see_data, :all
      can :see_history, :all
      can :manage, [Company, Apptype, Entry, Invoice, Stats, Broadcast, Stock, Shipment]
      can [:create, :destroy], [Attachment, Appliance, Classifications]
      can :type_stock, Stock

    elsif user.has_role? :technician
      can :see_data, :all
      can :manage, [Entry, Stats, Shipment]
      cannot [:destroy], Entry
      can [:create, :destroy], Attachment
      can [:retrieve, :disable], Broadcast
      can :index, [Apptype, Stock]
      can :type_stock, Stock

    # Add any company that exists here as a role
    elsif user.supplier?
      can :see_data, :all
      can [:index, :show], [Entry, Invoice, Attachment, Shipment]
      can :zip, Entry
      can :manage, Stats
      can [:retrieve, :disable], Broadcast
      can :index, [Apptype, Stock]
      can :slip, Invoice

    elsif user.has_role? :user
      # ...
    end

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
