class PaintSend < Hejia::Db::Hejia
  include ActivityLogger
  after_destroy :log_activity_destroy
  belongs_to :paint_worker
  has_one :email_delivery_record, :as => :resource
  
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
  
  BRANDS = {
    '多乐士' => 1,
    '来威漆' => 2
  }
 
 # 改版后，暂时不用
# star#############
#  DUOLESHI_CITY = {
#    "四川" => ["成都", "泸州"],
#    "江苏" => ["南京"],
#    "辽宁" => ["大连"],
#    "陕西" => ["咸阳"],
#    "湖北" => ["襄樊"],
#    "河北" => ["邢台"],
#    "山西" => ["晋城"],
#    "福建" => ["宁德"]
#  }
#  
#   LAIWEIQI_CITY = {
#      "福建" => ["宁德"]
#   } 
# end ##############
  
  
  def paint_worker_name
    self.paint_worker.blank? ? "没有选择油工" : self.paint_worker.USERBBSNAME
  end
  
  named_scope :is_remark , lambda { |status| 
      conditions = status.to_i == 0 ?  "remark is null" : "remark is not null"
      {:conditions => conditions,
       :order => 'updated_at desc'
      }
    } 
  
    #所有未备注的派遣申请列表
  named_scope :mail_show,:conditions => " id not in (SELECT resource_id FROM email_delivery_records WHERE resource_type = 'PaintSend')"
   
  named_scope :by_all, lambda{ |params|
   conditions = []
   condition_params = []
   unless params[:status].blank?
    conditions << ( params[:status].to_i == 0 ?  "remark is null" : "remark is not null" )
   end
   unless params[:hope_start_date].blank?
     conditions << "hope_date >= ?"
     condition_params << "#{params[:hope_start_date]} 00:00:00"
   end
   unless params[:hope_end_date].blank?
     conditions << "hope_date <= ?"
     condition_params << "#{params[:hope_end_date]} 23:59:59"
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
    add_activities(:item => self ,:change => "<em>修改了</em>用户(#{self.people})的油漆工派遣申请的备注")
  end   
  
  private
   def log_activity_destroy
    add_activities(:item => self ,:change => "<em>删除了</em>用户(#{self.people})的派遣申请")
  end
  
  
end
