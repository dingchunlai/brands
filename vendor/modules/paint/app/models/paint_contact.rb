class PaintContact < Hejia::Db::Hejia
  include ActivityLogger
  after_create :log_activity_create
  after_update :log_activity_update
  after_destroy :log_activity_destroy
  
  named_scope :by_contact, lambda{ |params|
    conditions = []
    condition_params = []
    unless params[:people].blank?
      conditions << ["contact_people like ?"]
      condition_params << "%#{params[:people]}%"
    end
    unless params[:phone].blank?
      conditions << ["phone like ?"]
      condition_params << "%#{params[:phone]}%"
    end
    unless params[:province].blank?
      conditions << ["province = ?"]
      condition_params << params[:province]
    end
    unless params[:city].blank?
      conditions << ["city = ?"]
      condition_params << params[:city]
    end
    {
      :conditions => [conditions.join(' and ')] + condition_params,
      :order => 'id desc'        
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
  
  
  def self.get_contact id
    PaintContact.find id
  end
  
  #得到现有数据的省份
  def self.get_province
    PaintContact.find(:all, :select => 'distinct(province)', :conditions => "province is not null")
  end
  #得到省下的城市
  def self.cities_for_province province
    cities = PaintContact.find(:all, :select => 'distinct(city)', :conditions => ["province = ? and city is not null", province])
    cities_array = []
    cities.each do |c|
      cities_array << [City.name_for_code(c.city), c.city]
    end
    cities_array
  end
  
   private
   def log_activity_create
     add_activities(:item => self, :change => "<em>创建了</em>联系中心(#{self.contact_name})")
   end
   
   def log_activity_destroy
     add_activities(:item => self ,:change => "<em>删除了</em>联系中心(#{self.contact_name})")
   end
   
   def log_activity_update
     add_activities(:item => self ,:change => "<em>修改了</em>联系中心(#{self.contact_name})")
  end
 
  
end
