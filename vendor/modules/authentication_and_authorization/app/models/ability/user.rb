# encoding: utf-8
# @author: Gimi Liang

# 对现有的两种用户(HEJIA_USER_BBS, radmin_users)的统一封装
class Ability::User

  attr_reader :users
  private     :users

  # @private
  def initialize(*users)
    @users =
      users.map { |user|
        klass = Base.find_match_class_for user
        fail "Unknow user type! #{user.inspect}" unless klass
        klass.new user
      }
  end

  # 获取用户的所有权限
  def permissions; @permissions ||= users.map { |user| user.permissions }.flatten! end

  # 用户所有角色
  def roles
    @roles ||= begin
                 roles = users.map { |user| user.roles }.flatten!
                 roles.uniq!
                 roles
               end
  end

  # 判断用户是否拥有某个角色
  def member_of?(role)
    roles.include? role
  end

  private

  # 外部用户？
  def external?; users.any? { |user| External === user } end
  # 内部用户？
  def internal?; users.any? { |user| Internal === user } end

  # this should be a proxy to user.
  def method_missing(m, *args, &blk)
    users.each { |user|
      begin
        return user.__send__(m, *args, &blk)
      rescue NoMethodError
        # try next
      end
    }
    super
  end

  # 用户基类
  class Base
    attr_reader :user
    private     :user

    class_inheritable_accessor :table_name

    def self.inherited(sub)
      super

      @@subclasses ||= []
      @@subclasses << sub
      @@subclasses.uniq!
    end

    def self.find_match_class_for(user)
      @@subclasses.detect { |sub| sub.match? user }
    end

    def self.match?(user)
      user.class.table_name == table_name
    end

    # @private
    def initialize(user)
      fail "#{user.inspect} is not a #{self.class.table_name} record." unless user.class.table_name == self.class.table_name
      @user = user
    end

    # 获取用户的所有权限
    def permissions
      @permissions ||= roles.inject([]) { |p, r| p.concat r.permissions }
    end

    private

    # this should be a proxy to user.
    def method_missing(m, *args, &blk)
      begin
        user.__send__ m, *args, &blk
      rescue NoMethodError
        super
      end
    end
  end

  # 外部用户（注册会员）
  class External < Base
    self.table_name = 'HEJIA_USER_BBS'

    # 所有外部角色
    def self.roles
      # TODO 按理应该通过inherited方法，来获得各种角色，但基于autoload的机制，做起来比较麻烦，特别是在development环境下。
      @roles ||= [HejiaUserBbs, PaintAdmin, PaintWorker, DistributorAccount].inject([]) { |roles, user_class| roles.concat user_class.role_names }
    end

    # TODO 给所有属性统一命名
    # 统一用户名属性
    def username; user.USERNAME end

    # 得到用户所有的角色
    # @readonly
    def roles
      @roles ||=
        begin
          (roles = [::Ability::Role.find_by_name(*user.role_names)]).flatten!
          roles.freeze
          roles
        end
    end
  end

  # 公司内部用户（公司员工）
  class Internal < Base
    self.table_name = 'radmin_users'

    # 所有内部角色
    def self.roles
      Webpm.find(:all, :select => 'value', :conditions => {:keyword => 'role'}, :order => 'id asc').map! { |pm| pm.value }
    end

    # 统一用户名属性
    def username; user.name end

    # 得到用户所有的角色
    # @readonly
    def roles
      @roles ||=
        begin
          (roles = [
           ::Ability::Role.find_by_name(
              *Webpm.find(:all,
                         :select => "value",
                         :conditions => ["keyword = ? and id in (?)", 'role', user.role.blank? ? [] : user.role.split(',')]
                        ).map! { |pm| pm.value }
            )
          ]).flatten!
          roles.freeze
          roles
        end
    end
  end
end
