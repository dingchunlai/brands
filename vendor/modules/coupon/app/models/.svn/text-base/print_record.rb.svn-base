# 此表中有属性 amount 数量只打印的数量
# tag_amounts 行业数量设置表中记录的amount 数量是指 某行业的数量信息

class PrintRecord < ActiveRecord::Base
  
  has_many :tag_amounts
  belongs_to :city_obj, :class_name => 'City', :primary_key => 'pinyin', :foreign_key => 'city'
  
  validates_presence_of :month, :amount, :city
  validates_uniqueness_of :month, :message => "此月份信息已经存在"

  named_scope :with_city, lambda{|city|
    {
      :conditions => (city.blank? ? nil : ["city = ?", city]),
      :order => "month DESC"
    }
  }

  def month=(month)
    raise "格式不正确 {2010-10-10}" unless month =~ /[19|20]\d{2}-\d{1,2}-\d{1,2}/ 
    write_attribute(:month, month.to_date.at_beginning_of_month().to_s(:db))
  end

  def city_obj1
    City.with_pinyin(city)
  end

end
