class Market < ActiveRecord::Base
  has_many :market_shops
  accepts_nested_attributes_for :market_shops, :reject_if => lambda { |m| m[:when_market_create] == "0" }

  validates_presence_of :name
  validates_uniqueness_of :name

  default_scope :conditions => { :deleted => false }

  named_scope :search, lambda { |name|
      {
              :conditions => name.to_s.blank? ? nil : ["name like ?", "%#{name}%"]
      }
  }

  named_scope :with_city, lambda { |city_id|
    market_ids = MarketShop.with_city(city_id).map(&:market_id).uniq
    {
      :conditions => ["id in (?)", market_ids],
      :include => :market_shops
    }
  }



  def mark_deleted
    update_attributes(:deleted => true)
  end

  class << self

    def record_by_id(id)
      id.to_i > 0 ? self.first(:select => 'id, name', :conditions => ['id = ?', id]) : nil
    end

    def id_to_name(object)
      object = record_by_id(object) if object.class != self
      return '' if object.nil?
      object.name
    end

  end

end
