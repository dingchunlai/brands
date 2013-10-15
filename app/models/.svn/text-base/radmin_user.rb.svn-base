# == Schema Information
#
# Table name: radmin_users
#
#  id              :integer(11)     not null, primary key
#  name            :string(127)     default(""), not null
#  password        :string(127)     default(""), not null
#  rname           :string(127)
#  cdate           :datetime        default(Fri Dec 31 00:00:00 +0800 1999), not null
#  udate           :datetime        default(Fri Dec 31 00:00:00 +0800 1999), not null
#  idate           :datetime        default(Fri Dec 31 00:00:00 +0800 1999), not null
#  role            :string(127)     default("0"), not null
#  description     :string(255)
#  login_num       :integer(11)     default(0), not null
#  last_login      :datetime
#  editer_id       :integer(11)
#  department      :integer(11)
#  state           :integer(4)
#  month_login_num :integer(11)     default(0), not null
#  parent_id       :integer(5)
#  pw_md5          :string(32)
#

class RadminUser < Hejia::Db::Hejia
  #  validates_presence_of :name, :message=>"<script>alert('用户名必须填写!');</script>"
  #  validates_presence_of :password, :message=>"<script>alert('密码必须填写!');</script>"
  #  validates_presence_of :role, :message=>"<script>alert('用户角色必须选择!');</script>"
  #  validates_uniqueness_of :name, :message=>"<script>alert('您输入的用户名已经被占用!');</script>"

  def allowed?(obj)
    obj.respond_to?(:owned_by) ? self : false
  end

  def owned_contracts
    if role_names.include?("抵用券业务经理")
      ids = SalesProfile.with_manage_sales(self.id).map &:user_id
      Distributor::Contract.find(:all, :conditions => ["radmin_user_id in (?)" , ids]).map &:id
    elsif role_names.include?("抵用券业务员")
      Distributor::Contract.find(:all, :conditions => ["radmin_user_id = ?" ,self.id]).map &:id
    else
      []
    end
  end

  PROFILE_MAPPING = {
    '抵用券业务员' => SalesProfile
    #'业务员经理' => SalesManagerProfile
  }

  def profile_for(role_name)
    profile_model_for(role_name).try :find_by_user, self if member_of?(role_name)
  end

  def profile
    SalesProfile.find_by_user_id(self.id)
  end

  # 取得某后台用户的所有角色名称
  def role_names
    unless role.blank?
      roles =  RadminRole.all :select => "value", :conditions => ["id in (?)", role.split(",")]
      roles.map &:value 
    else
      "---"
    end
  end

  class << self

    # 迫不得已只有写死
    # 抵用券业务员
    def with_sales
      roles = RadminRole.find(:all, :select => "id", :conditions => ["keyword = ? and value LIKE ?", 'role', '%抵用券%'])
      unless roles.blank?
        u = []
        roles.map(&:id).each do |role_id|
          user = find(:all, :select => "id, rname, role", :conditions => ["role like ?", "%#{role_id}%"]) 
          u << user unless user.blank?
        end
        u.flatten!
        u.uniq
      else
        []
      end
    end

    def coupon_sales
      roles = RadminRole.find(:all, :select => "id", :conditions => ["keyword = ? and value LIKE ?", 'role', '%抵用券业务员%'])
      unless roles.blank?
        u = []
        roles.map(&:id).each do |role_id|
          user = find(:all, :select => "id, rname, role", :conditions => ["role like ?", "%#{role_id}%"])
          u << user unless user.blank?
        end
        u.flatten!
        u.uniq
      else
        []
      end
    end

    # 迫不得已只有写死
    # 抵用券业务员
    def with_manager_sales
      role = RadminRole.find(:first, :select => "id", :conditions => ["keyword = ? and value = ?", 'role', '抵用券业务经理'])
      unless role.blank?
        find(:all, :select => "id, rname", :conditions => ["role like ?", "%#{role.id}"]) 
      else
        []
      end
    end
  end

  private
  def profile_model_for(role_name)
    PROFILE_MAPPING[role_name]
  end

end
