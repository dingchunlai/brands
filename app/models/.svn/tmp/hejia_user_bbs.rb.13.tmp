class HejiaUserBbs < Hejia::Db::Hejia
  set_table_name "HEJIA_USER_BBS"
  set_primary_key "USERBBSID"
  set_inheritance_column 'class_name'

  # Ability::User用到的接口
  class << self; attr_accessor :role_names end
  self.role_names = ['普通和家网用户']

  validates_presence_of :USERNAME, :message => "用户名不能为空"
  validates_uniqueness_of :USERNAME, :message => "用户名已经存在"

  attr_accessor :PASSWORD_CONFIRMATION

  has_many :questions, :foreign_key => "user_id"
  has_many :remarks,  :foreign_key => "user_id"
  belongs_to :deco_firm, :class_name => "DecoFirm", :foreign_key => "deco_id"
  
  validates_presence_of :USERNAME ,:allow_blank => false, :message => "用户名不能为空"
  validates_uniqueness_of :USERNAME,  :message => "用户名已被占用", :unless => Proc.new { |hub| hub.USERNAME.blank? } 
  
  before_create :add_default_value

  named_scope :used_user, :select => "USERBBSID, USERNAME", :conditions => ["USERNAME is not null and freeze_date is null"], :order => "USERBBSID DESC", :limit => 100

  #导出
  named_scope :xls, lambda{|start_date,end_date|
    conditions = []
    condition_params = []
    conditions << "concerned_paint = ?"
    condition_params << '1'
    unless start_date.blank?
      conditions << "CREATTIME >= ?"
      condition_params << start_date
    end
    unless end_date.blank?
      conditions << " CREATTIME <= ?"
      condition_params << end_date
    end
    {
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'CREATTIME desc',
    }
  }
  
  def self.get_user id
    find_by_USERBBSID id
  end
  
  def latest_remark
    self.remarks.find(:first,:order=>"created_at desc")
  end

  # Ability::User用到的接口
  def role_names
    ::HejiaUserBbs.role_names
  end
  
  def USERSPASSWORD=(password)
    return if password.blank?
    write_attribute(:USERSPASSWORD, Digest::MD5.hexdigest(password))
  end
  
  #会员登录验证
  def self.authenticate(name, password)
    HejiaUserBbs.find(:first, :select => "userbbsid, deco_id, freeze_date",
      :conditions => ["username = ? and userspassword = ?", name, Digest::MD5.hexdigest(password)])
  end
  
  # 用户头像
  def avatar
    self.HEADIMG || "http://member.51hejia.com/images/headimg/default.gif"
  end
  
  
  private

  def add_default_value
    self.CREATTIME = Time.now
    self.BBSID = 0
  end
  
  
end
