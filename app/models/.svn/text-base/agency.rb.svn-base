class Agency < ActiveRecord::Base
  belongs_to :tagged_brand
  
  validates_presence_of :title
  validate :validate_city

  belongs_to :city_obj, :class_name => 'City', :primary_key => 'pinyin', :foreign_key => 'city'


  named_scope :with_title, lambda { |title|{
      :conditions => ["title like ?", "%#{title}%"]
    }
  }
  
  named_scope :with_tagged_brand, lambda { |tagged_brand_id|
    {
      :conditions => ["tagged_brand_id = ?", tagged_brand_id]
    }
  }

  named_scope :tagged_brand_and_city, lambda { |tagged_brand, city, limit|
    {
      :conditions => ["tagged_brand_id = ? and city = ?", tagged_brand, city],
      :order => "updated_at DESC",
      :limit => limit
    }
  }
 
  def validate_city
    if self.city == "全国" || self.city == "quanguo"
      write_attribute(:city, 'quanguo')
    else
      obj = City.find_by_pinyin(self.city)
      unless obj.blank?
        write_attribute(:city, obj.pinyin)
      else
        obj = City.find_by_name(self.city)
        unless obj.blank?
          write_attribute(:city, obj.pinyin)
        else
          errors.add('城市输入错误  正确格式: [上海|shanghai]')
        end
      end
    end
  end


end
