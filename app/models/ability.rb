class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    if user.super_admin?
      can :manage, :all
    elsif user.employer?
      can [:create, :read, :new], Keypad
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :read, [User, Answer]
    else
      can :read, :all
    end

  end
end
