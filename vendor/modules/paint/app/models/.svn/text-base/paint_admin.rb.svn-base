class PaintAdmin < HejiaUserBbs

  # 除了PaintAdmin::AdminController，本项目里面还定义了::AdminController。
  # 在除了开发模式外的其它模式下，如果一旦先载入了::AdminController，
  # 就会导致PaintAdmin::AdminController不会载入。以下代码就是为了解决这个问题。
  autoload :AdminController, File.expand_path('../../controllers/paint_admin/admin_controller', __FILE__)
  
  include ActivityLogger
  
  after_create :log_activity_create
  after_update :log_activity_update
  after_destroy :log_activity_destroy
  
  has_many :paint_logs, :as => :item
  has_many :paint_log, :class_name => "PaintLog",  :foreign_key => "user_id"

  validates_presence_of :USERSPASSWORD, :message => "密码不能为空"
  validates_presence_of :USERBBSNAME, :message => "姓名不能为空"
  validates_format_of :USERBBSEMAIL, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i ,:message => "请输入正确的邮件地址"
  
  named_scope :username_like , lambda { |username| { :conditions => (["USERNAME like ?","%#{username}%"] unless username.blank?)  }}
  named_scope :userbbsname_like  , lambda { |username|{ :conditions => (["USERBBSNAME like ?","%#{username}%"] unless username.blank?)}}
  named_scope :email_is, lambda { |email|{  :conditions => (["USERBBSEMAIL = ? ",email] unless email.blank?  )}}

  ROLES = {
    '油漆工管理员' => 1,
    '油漆工审核员' => 2,
    '油漆工评分员' => 4
  }

  self.role_names = ROLES.keys

  # 所有角色的名字
  # Ability::User里面使用到的接口
  def role_names
    super +
    self.class.role_names.inject([]) { |names, name|
      names << name if has_role?(name)
      names
    }
  end

  def reset_role
    self.roles = 0
  end

  def add_role role
    self.roles ^= role
  end

  def set_roles roles
    reset_role
    roles && roles.each do |role|
      self.add_role role.to_i
    end
  end

  def has_role? role
    (self.roles & ROLES[role]) == ROLES[role]
  end

  def roles_for_show
    roles = []
    ROLES.each do |key,value|
      roles << key if self.has_role? key
    end
    roles.join(" ")
  end

  def self.get_all
    PaintAdmin.find(:all,:select => "USERBBSID,USERNAME,USERBBSNAME")
  end

  #修改密码
  def password_update password
    update_attribute(:USERSPASSWORD, password)        
  end

  private
  def log_activity_create
    add_activities(:item => self, :change => "<em>创建了</em>后台用户(#{self.USERNAME})")
  end

  def log_activity_destroy
    add_activities(:item => self ,:change => "<em>撤销了</em>后台用户(#{self.USERNAME})")
  end

  def log_activity_update
    add_activities(:item => self ,:change => "<em>修改了</em>后台用户(#{self.USERNAME})的资料")
  end

end
