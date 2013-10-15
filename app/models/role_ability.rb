class RoleAbility < ActiveRecord::Base

  ROLES = ['游客', '管理员', '后台维护', '经销商']
  OPERATIONS = ['manage', 'read', 'create', 'update', 'destroy']
  OBJECTS = [':all', 'Tag', 'Brand', 'ProductionCategory', 'Distributor', 'Distributor::Shop', 'Distributor::Contract', 'Coupon']
  
#       can :manage, :all
#       can :read, :all
#       can :update, :all
#      can :read, :all
#      can :create, Comment
#      can :update, Comment do |comment|
#        comment.try(:user) == user || user.role?(:moderator)
#      end
#      if user.role?(:author)
#        can :create, Article
#        can :update, Article do |article|
#          article.try(:user) == user

  validates_presence_of :role_id, :operation, :object

  named_scope :by_role, lambda { |role_id|
    { :conditions => ["role_id = ?", role_id]}
  }

  def role_name
    ROLES[role_id]
  end

  def operation_name
    OPERATIONS[operation]
  end
  

end
