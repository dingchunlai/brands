class Painter < Hejia::Db::Hejia
  include ActivityLogger
  validates_format_of :id_number, :with => /^\d{15}$|(\d{17}(?:\d|x|X)$)/, :message => "请输入正确的身份证号码"
  validates_presence_of :address, :message => "地址不能为空"
#  validates_numericality_of :job_year, :message => "工作年限必须为数字"
  
  belongs_to :paint_worker, :foreign_key => "user_id"
  has_many :paint_logs, :as => :item
  
  has_attached_file :avatar, :styles => { :original => ["128x168#", :png]} ,
    :url => "/upload/images/avatar/:id_:style.:extension",
    :default_url => '/upload/images/avatar/default/missing.jpg',
    :path => ":rails_root/public/upload/images/avatar/:id_:style.:extension" 
    
  
  named_scope :by_status , lambda { |status| { :conditions => ["painters_status = ?",status] }}
  named_scope :by_created , lambda { |start_data , end_data| { :conditions => ["created_at >= ? and created_at <= ?" ,start_data , end_data] } }
  named_scope :by_order , :conditions => "user_id is not null" ,:order => "updated_at desc" 
  named_scope :get_province, :select => 'distinct(province)',:conditions => "province is not null"
  
  
    #得到省下的城市
  def self.cities_for_province province
    cities = Painter.find(:all, :select => 'distinct(city)', :conditions => ["province = ? and city is not null and painters_status = 1", province])
    cities_array = []
    cities.each do |c|
      cities_array << [City.name_for_code(c.city), c.city]
    end
    cities_array
  end

  BRAND = {
      "多乐士" => "1",
      "来威" => "2",
      "其它" => "0"
  }
  GRADE = { #等级
    "初级" => 1,
    "中级" => 2,
    "高级" => 3,
    "技师级" => 4
  }
  
  PAINTERS_STATUS = { #状态
    "已审核" => 1,
    "等待审核" => 2,
    "未通过审核" => 3
#    4 => "已撤销"
  }
  CERTIFICATES = { #等级 
    "初级" => 1,
    "中级" => 2,
    "高级" => 3,
    "技师级" => 4
  }
  
  GENDER = {
    "男" => 1,
    "女" => 2
  }
  EDUCATION = ["大学","大专","高中","中专","初中"] #文化成度
  KNOW_HERE = ["店员介绍","其它油漆工介绍","装修公司介绍"] #如何知道这里
  JOBS = ["装修队队长","漆工"] #目前职业
  TRIAL_PRODUCTS = ["多乐士净味全效系列","多乐士智动修痕全效系列","多乐士5合一系列","多乐士强效抗划系列",
                    "多乐士倍饰易系列","多乐士木饰丽系列","立邦1系列","立邦6系列","立邦8系列","立邦7系列",
                    "立邦立邦保优丽超透","华润10系列","华润20系列","华润30系列","华润40系列"]
  
  def user_name
    paint_worker ? paint_worker.USERNAME : '无效用户'
  end
  
  #油漆工恢复
  def regain
    update_attribute(:painters_status, 2)
    add_activities(:item => self ,:change => "<em>撤销了</em>油漆工(#{self.user_name})")
  end 
  #油漆工撤销
  def trash 
    update_attribute(:painters_status, 4)
    add_activities(:item => self ,:change => "<em>撤销了</em>油漆工(#{self.user_name})")
  end
  
  #油漆工申请通过
  def agree
    update_attribute(:painters_status, 1)
    add_activities(:item => self ,:change => "<em>通过了</em>油漆工(#{self.user_name})的申请")
  end
  
   #油漆工申请驳回
  def reject
    update_attribute(:painters_status, 3)
    add_activities(:item => self ,:change => "<em>取消了</em>油漆工(#{self.user_name})的申请")
  end
  
end
