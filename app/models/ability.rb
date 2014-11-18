class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can [:read, :attend, :leave], Location
      can :manage, Message
      can [:show, :invite, :profile], User
      can :index, Notification
    end
  end
end
