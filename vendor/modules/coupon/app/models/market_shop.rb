class MarketShop < ActiveRecord::Base
  attr_accessor :when_market_create

  belongs_to :city
  belongs_to :district
  belongs_to :business_zone
  belongs_to :market, :counter_cache => true

  validates_presence_of :name, :city_id, :district_id, :market_id, :address#, :business_zone_id
  validates_format_of :market_id, :with => /^[1-9]\d*$/, :if => Proc.new { |s| s.when_market_create == "0" }
  validates_format_of :city_id, :district_id, :with => /^[1-9]\d*$/ #, :business_zone_id

  default_scope :conditions => { :deleted => false }

  named_scope :with_locations, :include => [:city, :district, :business_zone, :market]

  named_scope :by_business_zone, lambda { |business_zone_id|
    if business_zone_id.to_i == 0
      {:conditions => ["business_zone_id = 0 or business_zone_id is null"]}
    else
      {:conditions => ["business_zone_id = ?", business_zone_id]}
    end
  }

  named_scope :by_district, lambda { |district|
    {:conditions => ["district_id = ?", district]}
  }

  named_scope :with_city, lambda { |city|
    {:conditions => ["city_id = ?", city]}
  }


  class << self

    def record_by_id(id)
      return nil unless id.to_i > 0
      MarketShop.first(:select => 'id, name, market_id, business_zone_id, district_id', :conditions => ['id = ?', id])
    end

    def id_to_name(id, include_market_name = false)
      marketshop = record_by_id(id)
      return '' if marketshop.nil?
      if include_market_name
        market_name = marketshop.market.name
        (market_name != marketshop.name ? market_name : '') + marketshop.name
      else
        marketshop.name
      end
      
    end

    def mark_deleted
      update_attributes(:deleted => true)
    end

  end

  def market_name
    market.name
  end

end
