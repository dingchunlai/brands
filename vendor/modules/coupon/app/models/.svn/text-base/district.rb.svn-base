class District < ActiveRecord::Base
  has_many :business_zones
  belongs_to :city, :counter_cache => true
  has_many :offline_addresses

  validates_presence_of :name, :pinyin, :code_name, :city_id
  validates_format_of :city_id, :with => /^[1-9]\d*$/

  default_scope :conditions => { :deleted => false }
  

  named_scope :by_city, lambda{ |city|
    { :conditions => ["city_id = ?", city] }
  }

  def mark_deleted
    if update_attributes(:deleted => true)
      City.decrement_counter(:districts_count, city_id)
      self.business_zones.each do |biz|
        biz.mark_deleted
      end
    end
  end

  class << self

    def record_by_id(id)
      return nil unless id.to_i > 0
      District.first(:select => 'id, name', :conditions => ['id = ?', id])
    end

    def id_to_name(id)
      district = record_by_id(id)
      return '' if district.nil?
      district.name
    end

  end

end
