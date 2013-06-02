class Ability
  include CanCan::Ability
  
  # initialize a new user
  user ||= User.new

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    else
      can :read, :all
    end
  end
end
