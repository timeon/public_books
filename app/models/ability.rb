class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    
    can :read,   Category         # all pages are public for reading
    can [:read, :toc],   Course   # all courses are public for reading
    can :read,   Lesson           # all lessons are public for reading
    can :read,   Author           # all authors are public for reading
    
    can :manage, user # user can manage own account
    
    if user.has_role? :admin
      can :manage, :all # admin can perform all actions on all resources 
   end    
  
  end
end
