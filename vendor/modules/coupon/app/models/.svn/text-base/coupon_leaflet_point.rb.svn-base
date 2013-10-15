class CouponLeafletPoint < ActiveRecord::Base
  belongs_to :city
  belongs_to :district
  validates_presence_of :address, :city_id, :district_id, :activity_begin_at, :activity_end_at
  
  default_scope :conditions => { :deleted => false }

  named_scope :with_district_id, lambda { |district|
    {
        :conditions => ["district_id = ?", district]
    }
  }

  class << self
    def city_default_redis_key(city = "上海")
      "coupon:leaflets:#{city}"
    end
  end

  def mark_deleted
    update_attributes(:deleted => true)
  end
end