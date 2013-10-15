class PaintCase < Hejia::Db::Hejia
  include ActivityLogger
  VSTING = [["满意","1"],["一般","0"],["不满意","-1"]]
  
  after_create :log_activity_create ,:if => :should_validate?
  after_update :log_activity_update , :if => :should_validate?
  after_destroy :log_activity_destroy ,:if => :should_validate?
  
  has_one :email_delivery_record, :as => :resource
  
  belongs_to :paint_worker
  accepts_nested_attributes_for :paint_worker

  has_many :wood_construction_specifications
  accepts_nested_attributes_for :wood_construction_specifications, :allow_destroy => true

  has_many :product_specifications
  accepts_nested_attributes_for :product_specifications, :allow_destroy => true

  has_many :paint_case_pictures, :order => "list_index desc", :dependent => :destroy
  accepts_nested_attributes_for :paint_case_pictures
  has_many :pictures, :through => :paint_case_pictures, :source => :picture

  # attr_protected :status #避免直接通过审核

  validates_presence_of :title , :if => :should_validate?
  # validates_presence_of :content , :if => :should_validate?

  before_save :add_title_for_draft 
  
  named_scope :created_at_after, lambda { |date|{  :conditions => (["created_at >= ? ",date] unless date.blank?  )}}
  named_scope :created_at_before, lambda { |date|{  :conditions => (["created_at <= ? ",date.to_date.tomorrow.to_s] unless date.blank?  )}}
  named_scope :title_like,lambda { |title|{  :conditions => (["title like ? ","%#{title}%"] unless title.blank?  )}}
  named_scope :status_is, lambda {|status|{ :conditions => (["status = ? ",status.to_i] unless status.blank?  )}}
  named_scope :exception_draft, :conditions => "status = 1 or status = 0" ,:order => "created_at desc"
  named_scope :essence_case, :conditions => "status = 1 and essence = 1", :order => "created_at desc"

  named_scope :except_status, :conditions => ["status <> ?", -2]
  
  named_scope :paint_worker_name_is ,lambda {|paint_worker_name|    
    unless paint_worker_name.blank?
      {
        :joins => 'join HEJIA_USER_BBS on paint_cases.paint_worker_id = HEJIA_USER_BBS.USERBBSID',
        :conditions => "HEJIA_USER_BBS.USERNAME = '#{paint_worker_name}'",
        :order => 'paint_cases.created_at desc'
      }
    end
  }
  
  #所有未发邮件的派遣申请列表
  named_scope :mail_show,:conditions => " id not in (SELECT resource_id FROM email_delivery_records WHERE resource_type = 'PaintCase')"
  
  SHOW_STATUS = {
    '彻底删除' => -2,
    '删除' => -1,
    '待审核' => 0,
    '通过' => 1
  }
  
  STATUS = {
    '删除' => -1,
    '待审核' => 0,
    '通过' => 1
  }
 
  ROOM = {
    '一室' => 1,
    '一室一厅' => 2,
    '二室' => 3,
    '二室一厅' => 4,
    '二室二厅' => 5,
    '三室一厅' => 6,
    '三室两厅' => 7,
    '别墅' => 8,
    '其他' => 9
  }
  
  WOOD_PAINT = ['多乐士净味环保全效木器漆', '多乐士竹炭清新居全效木器漆', '多乐士智动修痕全效清味木器漆', 
    '多乐士5合1清味木器漆', '多乐士水晶莹清味漆（高光）','多乐士强效抗划清味木器漆''多乐士莹钻清味木器漆',
    '多乐士倍饰易木器漆','多乐士木饰丽木器漆','多乐士雅木家木器漆'
  ]
  
  RENOVATION = ['新房装修','旧房翻新']
  
  WALL_TECHNOLOGY = {
    '贴画工艺' => 1,
    '人工绘画工艺' =>2,
    '墙面效果工艺' => 3
  }

  WOOD_PAINT_TECHNOLOGY = {
    '面修色' => 1,
    '底擦色' => 2,
    '点睛' => 3,
    '水洗白' => 4,
    '风化' => 5,
    '做旧' => 6,
    '半开放' => 7
  }

 
  
  def should_validate?
    status != 2
  end

  def renovation_description
    array = []
    array << "新房装修" if self.renovation_c1 and self.renovation_c1 != "0"
    array << "旧房翻新" if self.renovation_c2 and self.renovation_c2 != "0"
    array << self.renovation if self.renovation_other and self.renovation_other != "0" and self.renovation
    array.join("、")
  end


  ## 是否显示施工环境参数
  def is_show_environmental_params
    !self.temperature.blank? or !self.humidity.blank? or !self.is_dust.blank? or !self.product_mix.blank? or
    !self.diluent.blank? or !self.curing_agent.blank? or !self.is_clean.blank? or !self.low_material_description.blank?
  end

  def low_material_description
    array = []
    array << "刨光面" if self.low_material_c1 and self.low_material_c1 != "0"
    array << "砂纸打磨表面" if self.low_material_c2 and self.low_material_c2 != "0"
    array << "抛光表面" if self.low_material_c3 and self.low_material_c3 != "0"
    array << self.low_material_other_description if self.low_material_other and self.low_material_other != "0" and self.low_material_other_description
    array.join("；")
  end


  def self.vsting(evalution)
    string = VSTING.rassoc(evalution).nil? ? "暂无评价" : VSTING.rassoc(evalution)[0]
    string
  end

  ## 是否显示乳胶漆施工规格
  def is_show_emulsion_paint
    (self.emulsion_paint_s1 and self.emulsion_paint_s1 != "0") or (self.emulsion_paint_s2 and self.emulsion_paint_s2 != "0") or (self.emulsion_paint_s3 and self.emulsion_paint_s3 != "0") or !self.emulsion_paint_description.blank? or !self.emulsion_paint_area.blank?
  end

  ## 是否显示乳胶漆验收
  def is_show_emulsion_paint_v
    self.emulsion_paint_v1 or self.emulsion_paint_v2 or self.emulsion_paint_v3 or self.emulsion_paint_v4 or self.emulsion_paint_v5 or self.emulsion_paint_v6
  end

  ## 是否显示木质表面混色油漆验收
  def is_show_wood_mixing_paint
    self.wood_mixing_paint_v1 or self.wood_mixing_paint_v2 or self.wood_mixing_paint_v3 or self.wood_mixing_paint_v4 or self.wood_mixing_paint_v5 or self.wood_mixing_paint_v6 or self.wood_mixing_paint_v7 or self.wood_mixing_paint_v8
  end

  ## 是否显示木质表面清漆验收
  def is_show_wood_varnish_paint
    self.wood_varnish_paint_v1 or self.wood_varnish_paint_v2 or self.wood_varnish_paint_v3 or self.wood_varnish_paint_v4 or self.wood_varnish_paint_v5
  end

  ## 是否显示服务质量验收
  def is_show_service
    self.service_v1 or self.service_v2 or self.service_v3
  end

  private
  
  def add_title_for_draft
    #如果是在保存草稿,没有标题,但是内容长度大于500,那么就给title取名未命名
    self.title = "未命名" if self.title.blank? && self.status == 2
  end
  
  def log_activity_create
    add_activities(:item => self, :change => "<em>创建了</em>案例(#{self.title})")
  end
   
  def log_activity_destroy
    add_activities(:item => self ,:change => "<em>撤销了</em>案例(#{self.title})")
  end
   
  def log_activity_update
    add_activities(:item => self ,:change => "<em>修改了</em>案例(#{self.title})的资料")
  end
  
end

