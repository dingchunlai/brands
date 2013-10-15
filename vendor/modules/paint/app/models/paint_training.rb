class PaintTraining < Hejia::Db::Hejia
  include ActivityLogger
  
  has_one :email_delivery_record, :as => :resource
  
  after_destroy :log_activity_destroy
  
  belongs_to :paint_worker,  :foreign_key => "user_id"
  
  HOPE_GRADE = { #希望培训等级
    "初级" => 1,
    "中级" => 2,
    "高级" => 3
  }
  
  
   named_scope :is_remark , lambda { |status| 
      conditions = status.to_i == 0 ?  "remark is null" : "remark is not null"
      {:conditions => conditions,
       :order => 'updated_at desc'
      }
  } 
  
   #所有未发邮件的派遣申请列表
  named_scope :mail_show,:conditions => " id not in (SELECT resource_id FROM email_delivery_records WHERE resource_type = 'PaintTraining')"
  
  
  named_scope :by_all, lambda{ |params|
   conditions = []
   condition_params = []
   unless params[:status].blank?
    conditions << ( params[:status].to_i == 0 ?  "remark is null" : "remark is not null" )
   end
   unless params[:start_date].blank?
     conditions << "created_at >= ?"
     condition_params << "#{params[:start_date]} 00:00:00"
   end
   unless params[:end_date].blank?
     conditions << "created_at <= ?"
     condition_params << "#{params[:end_date]} 23:59:59"
   end
   {
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'created_at desc'        
   }
  }
  
    #导出
  named_scope :xls, lambda{|start_date,end_date|
    conditions = []
    condition_params = []
    unless start_date.blank?
      conditions << "created_at >= ?"
      condition_params << start_date
    end
    unless end_date.blank?
      conditions << " created_at <= ?"
      condition_params << end_date 
    end
      {
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'updated_at desc'        
      }
    }
  
  
  
  def update_remark(remark)
    update_attribute(:remark , remark)
    add_activities(:item => self ,:change => "<em>修改了</em>用户(#{self.user_name})的油漆工培训申请的备注")
  end
  
  def user_name
    self.paint_worker.nil? ? read_attribute(:user_name) : self.paint_worker.USERBBSNAME
  end
  
  def phone
    self.paint_worker.nil? ? read_attribute(:phone) : self.paint_worker.USERBBSMOBELTELEPHONE
  end
  
  def email
    self.paint_worker.nil? ? read_attribute(:email) : self.paint_worker.USERBBSEMAIL
  end
  
  def province
    self.paint_worker.nil? ? read_attribute(:province) : self.paint_worker.painter.province
  end
  
  def city
    self.paint_worker.nil? ? read_attribute(:city) : self.paint_worker.painter.city
  end
  
  def gender
    self.paint_worker.nil? ? read_attribute(:gender) : self.paint_worker.painter.gender
  end
  
  def job_year
    self.paint_worker.nil? ? read_attribute(:job_year) : self.paint_worker.painter.job_year
  end
  
  def certificate
    self.paint_worker.nil? ? read_attribute(:certificate) : self.paint_worker.painter.certificate
  end
  
  def education
    self.paint_worker.nil? ? read_attribute(:education) : self.paint_worker.painter.education
  end
  
  def spray_gun
    self.paint_worker.nil? ? read_attribute(:spray_gun) : self.paint_worker.painter.spray_gun
  end
  
  def brush
    self.paint_worker.nil? ? read_attribute(:brush) : self.paint_worker.painter.brush
  end
  
  #------------------------private YD的分割线--------------------------------------------
  
  private
   def log_activity_destroy
    add_activities(:item => self ,:change => "<em>删除了</em>油漆工(#{self.user_name})的培训申请")
  end
  
end
