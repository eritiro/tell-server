class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can [:show, :scan] , Location
      can [:read, :create], Comment
    end
  end
end
