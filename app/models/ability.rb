class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :read, [Location, Comment]
      can :create, Comment
    end
  end
end
