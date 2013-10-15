class BusinessZone < ActiveRecord::Base
  belongs_to :city
  belongs_to :district, :counter_cache => true
  has_many :market_shops

  validates_presence_of :name, :pinyin, :code_name, :city_id, :district_id
  validates_format_of :city_id, :district_id, :with => /^[1-9]\d*$/

  default_scope :conditions => { :deleted => false }

  def mark_deleted
    update_attributes(:deleted => true)
    District.decrement_counter(:business_zones_count, district_id)
  end

  named_scope :by_district, lambda{ |district_id|
    { :conditions => ["district_id = ?", district_id] }
  }

  named_scope :by_city, lambda{ |city|
    district_ids = District.find(:all, :conditions => ['city_id = ?', city]).map{|d| d.id}
    district_ids.length > 0 ? { :conditions => ['district_id in (?)', district_ids]} : {}
  }

  named_scope :with_city, lambda{ |city_id|
      city_id = city_id.is_a?(City) ? city_id.id : city_id
    { :conditions => ['city_id = ?', city_id] }
  }



  class << self

    def record_by_id(id)
      return nil unless id.to_i > 0
      BusinessZone.first(:select => 'id, name', :conditions => ['id = ?', id])
    end

    def id_to_name(id)
      zone = record_by_id(id)
      return '' if zone.nil?
      zone.name
    end

  end

end
