class DistributorAccount < HejiaUserBbs

  self.role_names = ['经销商']
  
#  set_inheritance_column :class_name
  validate :must_be_value

#  validates_confirmation_of :USERSPASSWORD, :PASSWORD_CONFIRMATION, :message => "两次输入密码不同", :unless => Proc.new { |user| user.PASSWORD.blank? }
#  validates_presence_of :USERSPASSWORD, :message => "密码不能为空"

  validates_format_of :USERBBSEMAIL, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "请输入正确的邮件地址"
  validates_uniqueness_of :USERBBSEMAIL

  validates_presence_of :USERNAME, :message => "姓名不能为空"
  validates_length_of :USERNAME, :within => 6..20
  validates_length_of :USERSPASSWORD, :within => 6..40
  validates_uniqueness_of :USERNAME

  validates_presence_of :USERBBSNAME, :USERBBSSEX

  attr_accessor :PASSWORD_CONFIRMATION

  has_many :settings, :as => :resource, :class_name => "AppResourceSetting"
  validates_associated :settings
  accepts_nested_attributes_for :settings

  has_many :industry_brands, :class_name => 'DistributorAccountIndustryBrand'

  # 配置
  def new_setting_attributes=(setting_attributes)
    setting_attributes.each do |attributes|
      settings.build(attributes)
    end
  end

  # 配置
  def existing_setting_attributes=(setting_attributes)
    settings.reject(&:new_record?).each do |setting|
      attributes = setting_attributes[setting.id.to_s]
      if attributes
        setting.attributes = attributes
      else
        settings.delete(setting)
      end
    end
  end

  def role_names
    super + self.class.role_names
  end

  def allowed?(obj)
    obj.respond_to?(:owned_by) ? self : false
  end

  def owned_contracts
    dap = DistributorAccountProfile.find_by_distributor_account_id(self.USERBBSID)
    Distributor::Contract.find(:all, :conditions => ["distributor_id = ?" ,dap.distributor_id]).map(& :id)
  end

  def USERSPASSWORD=(password)
    write_attribute(:USERSPASSWORD,  DistributorAccount.md5(password))
  end

  # 获取当前登录用户对应的经销商 
  def distributors
    Distributor.find :all, :conditions => ["id in (?)", DistributorAccountProfile.find_by_distributor_account_id(self.USERBBSID).distributor_id]
  end

  # shit 不知道何故要不能为空
  # 于是赋值为 0 
  def must_be_value 
    write_attribute(:BBSID, 0)
  end

  def deliver_welcome!
    Notifier.deliver_welcome(self)
  end
 
  private
  def self.md5(password)
    Digest::MD5.hexdigest(password)
  end

end
