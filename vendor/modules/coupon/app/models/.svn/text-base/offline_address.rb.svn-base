class OfflineAddress < ActiveRecord::Base

  belongs_to :city
  belongs_to :district

  validates_format_of :city_id, :with => /[1-9]\d*/, :message => "无效的城市编号", :on => :create
  validates_format_of :district_id, :with => /[1-9]\d*/, :message => "无效的区域编号"
  validates_presence_of :address, :message => "地址不能为空"
  
  default_scope :conditions => ["deleted = ?", false], :order => "id DESC"
 
  # 获取某个城市下线下发放地址
  named_scope :of_city, lambda{ |city| {
     :conditions => ["city_id = ?", city],
     :order => "id DESC"
    }
  }

  # 获取某个区域下线下发放地址
  named_scope :of_district, lambda { |area| {
      :conditions => ["district_id = ?", area],
      :order => "id DESC"
    }
  }

  def mark_deleted
    update_attribute :deleted, true
  end
  
end
