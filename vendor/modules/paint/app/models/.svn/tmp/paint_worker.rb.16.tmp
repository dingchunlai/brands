class PaintWorker < HejiaUserBbs

  self.role_names = ['油漆工']
    
  include ActivityLogger
  validates_presence_of :USERBBSMOBELTELEPHONE, :message => "电话不能为空"
  validates_uniqueness_of :USERBBSMOBELTELEPHONE,  :message => "电话已被占用"
#  validates_format_of :USERBBSEMAIL, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i ,:message => "请输入正确的邮件地址"
  has_one :painter, :foreign_key => "user_id"
  has_many :paint_logs, :as => :item
  has_one :email_delivery_record, :as => :resource
  has_many :paint_cases
  has_many :paint_sends
  has_many :paint_trainings
  accepts_nested_attributes_for :painter
  
 
  after_create :log_activity_create
  after_update :log_activity_update
  after_destroy :log_activity_destroy
  
    
  named_scope :find_paint_worker , lambda { |params|
    conditions = []
    condition_params = []
    
    unless params[:userbbsname].blank?
      conditions << "HEJIA_USER_BBS.USERBBSNAME like ?"
      condition_params << "%#{params[:userbbsname]}%"
    end
    unless params[:email].blank?
      conditions << "HEJIA_USER_BBS.USERBBSEMAIL like ?"
      condition_params << "%#{params[:email]}%"
    end
    unless params[:phone].blank?
      conditions << "HEJIA_USER_BBS.USERBBSMOBELTELEPHONE like ?"
      condition_params << "%#{params[:phone]}%"
    end
    unless params[:id_number].blank?
      conditions << "painters.id_number like ?"
      condition_params << "%#{params[:id_number]}%"
    end
    unless params[:grade].to_i == 0
      conditions << "painters.grade = ?"
      condition_params << params[:grade]        
    end
    unless params[:province].blank?
      conditions << "painters.province = ?"
      condition_params << params[:province]       
    end
    #conditions << " painters.painters_status = 1 "

    conditions = [conditions.join(' and ')] << condition_params
    conditions = conditions.flatten

    {
      :joins => 'join painters on HEJIA_USER_BBS.USERBBSID = painters.user_id',
      :conditions => conditions,
      :order => 'painters_status asc,painters.updated_at desc'
    }
  
  }
    
  named_scope :by_painter , lambda { |status , data|
    conditions = []
    condition_params = []
    conditions << "painters.painters_status = ?"
    condition_params << status
    unless data.blank?
      start_data = data + (" 00:00:00")
      end_data = data + (" 23:59:59")
      conditions << "painters.created_at >= ?"
      conditions << " painters.created_at <= ?"
      condition_params << start_data  
      condition_params << end_data
    end
      {
      :joins => 'join painters  on HEJIA_USER_BBS.USERBBSID = painters.user_id',
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'painters.updated_at desc'        
      }
    }
  
  named_scope :xls, lambda{|status,start_date,end_date|
    conditions = []
    condition_params = []
    conditions << "painters.painters_status = ?"
    condition_params << status
    unless start_date.blank?
      conditions << "painters.created_at >= ?"
      condition_params << start_date
    end
    unless end_date.blank?
      conditions << " painters.created_at <= ?"
      condition_params << end_date 
    end
      {
      :joins => 'join painters  on HEJIA_USER_BBS.USERBBSID = painters.user_id',
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'painters.updated_at desc'        
      }
    }
  
  
  #所有油工列表
  named_scope :by_all, lambda{|params|
    conditions = []
    condition_params = []
    conditions << "painters.painters_status = 1"
    unless params[:province].blank?
      conditions << "painters.province = ?"
      condition_params << params[:province]
    end
    unless params[:city].blank?
      conditions << "painters.city = ?"
      condition_params << params[:city]
    end
    {
      :joins => 'join painters  on HEJIA_USER_BBS.USERBBSID = painters.user_id',
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'painters.skill_score + painters.service_score desc, painters.created_at desc'
    }
  }  
  
  #油工top10
  named_scope :paint_top10, {
    :joins => 'join painters  on HEJIA_USER_BBS.USERBBSID = painters.user_id join paint_cases on paint_cases.paint_worker_id = HEJIA_USER_BBS.USERBBSID',
    :conditions => "painters.painters_status = 1 and paint_cases.status = 1",
    :group => "paint_cases.paint_worker_id",
    :order => 'painters.skill_score + painters.service_score desc, count(paint_cases.paint_worker_id) desc, painters.created_at desc',
    :limit => 10
  }

  #油工top10
  named_scope :have_workers, {
    :joins => 'join painters  on HEJIA_USER_BBS.USERBBSID = painters.user_id',
    :conditions => "painters.painters_status = 1",
    :order => 'painters.skill_score + painters.service_score desc',
  }
  
  #认证页面，补IP不足的情况
  named_scope :renzheng, lambda { |limit|
  {
    :joins => 'join painters  on HEJIA_USER_BBS.USERBBSID = painters.user_id',
    :conditions => "painters.painters_status = 1",
    :order => 'painters.skill_score + painters.service_score desc',
    :offset => 10,
    :limit => limit
  }}
  
  named_scope :not_send_mail,:conditions => " USERBBSID not in (SELECT resource_id FROM email_delivery_records WHERE resource_type = 'PaintWorker')"

  #所有申请人列表
  def self.mail_show
    PaintWorker.by_painter(2,nil).not_send_mail  
  end

  def role_names
    super + self.class.role_names
  end
      
  #修改密码
  def password_reset password
    update_attribute(:USERSPASSWORD, password)        
  end
  
  #案例数量
  def cases_amount
    self.paint_cases.status_is(1).length 
  end
  
  #判断密码是否正确
  def validate_passrord password
    self.USERSPASSWORD == Digest::MD5.hexdigest(password)? true : false
  end
  
  def self.get_paint_worker id
    PaintWorker.find_by_USERBBSID id
  end
      
  private
  def log_activity_create
    add_activities(:item => self, :change => "<em>创建了</em>油漆工(#{self.USERNAME})")
  end
     
  def log_activity_destroy
    add_activities(:item => self ,:change => "<em>撤销了</em>油漆工(#{self.USERNAME})")
  end
     
  def log_activity_update
    add_activities(:item => self ,:change => "<em>修改了</em>油漆工(#{self.USERNAME})的资料")
  end
 
end

