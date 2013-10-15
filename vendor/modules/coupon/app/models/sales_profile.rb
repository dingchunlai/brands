class SalesProfile < ActiveRecord::Base

  belongs_to :user, :class_name => "RadminUser", :primary_key => 'id', :foreign_key => 'user_id'
  belongs_to :city, :class_name => "City", :primary_key => "id", :foreign_key => "city_id"
  belongs_to :manager_user, :class_name => "RadminUser", :primary_key => 'id', :foreign_key => 'manager_id'

  validates_presence_of :city_id, :email, :mobile
  validates_format_of :mobile, :with => /^1[3|5|8]\d{9}$/, :message => '手机号码错误'

  named_scope :with_manage_sales, lambda{ |manage_id|
    {
      :conditions => ["manager_id = ?", manage_id]
    }
  }
end
