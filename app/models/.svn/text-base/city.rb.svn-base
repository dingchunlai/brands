class City < ActiveRecord::Base
  include Hejia::Location

  COMMON_CITIES = {1 => '上海', 2 => '南京', 132 => '苏州', 223 => '杭州', 131 => '无锡', 214 => '宁波'}

  belongs_to :province, :counter_cache => true
  has_many :districts
  has_many :offline_addresses
  has_many :location_relate_model, :as => :resource
  
  default_scope :conditions => { :deleted => false }

  validates_uniqueness_of :name
  validates_presence_of :name, :pinyin, :code_name
  validates_format_of :province_id, :with => /^[1-9]\d*$/
  
  named_scope :used_cities, :order => "pinyin ASC"

  # 根据拼音获取对象信息
  named_scope :with_pinyin, lambda {|pinyin|
    {
      :conditions => ["pinyin = ?", pinyin]
    }
  }

  named_scope :with_code, lambda {|code|
    {
      :conditions => ["code_name = ?", code]
    }
  }
  
  #得到和模块关联的城市
  named_scope :get_city_for_model ,lambda{ |model_name| 
    {
      :joins => "join location_relate_models  on cities.id = location_relate_models.resource_id and location_relate_models.resource_type = 'City'",
      :conditions => ["location_relate_models.model_name = ? " , model_name]
    }
  }
  
  #根据省份拼音找城市
  named_scope :get_cities_for_province , lambda{ |province_id |  {:conditions => ["province_id = ?",province_id]} }
  
  #多乐士城市调用(根据省份拼音)
  def self.get_cities_for_province_douleshi(pinying)
    province = Province.find_by_pinyin(pinying)
    #City.get_cities_for_province(province.id).get_city_for_model("多乐士").map{|p| [p.pinyin, p.name]} unless province.nil?
    City.get_cities_for_province(province.id).get_city_for_model("多乐士").map{|p| [p.pinyin, p.name] unless ["眉山","广汉","广元","德阳","齐齐哈尔","哈尔滨","长乐"].include?(p.name)}.compact unless province.nil?
  end

  #金刷子城市调用(根据省份拼音)
  def self.get_cities_for_province_jinshuazi(pinying)
    province = Province.find_by_pinyin(pinying)
    City.get_cities_for_province(province.id).get_city_for_model("金刷子").map{|p| [p.pinyin, p.name]}.compact unless province.nil?
  end
  
  def mark_deleted
    if update_attributes(:deleted => true)
      Province.decrement_counter(:cities_count, province_id)
      self.districts.each do |district|
        district.mark_deleted
      end
    end
  end

  class << self

    def record_by_id(id)
      return nil unless id.to_i > 0
      City.first(:select => 'id, name, pinyin', :conditions => ['id = ?', id])
    end

    def record_by_pinyin(pinyin)
      return nil if pinyin.blank?
      City.first(:select => 'id, name, pinyin', :conditions => ['pinyin = ?', pinyin])
    end

    def id_to_name(id)
      city = record_by_id(id)
      return '' if city.nil?
      city.name
    end

    def pinyin_to_id(pinyin)
      city =  pinyin.blank? ? nil : self.first(:conditions => ["pinyin = ?", pinyin])
      city ? city.id : 0
    end

    def select_options
      City.find(:all, :select => 'id, name').map{|c| [c.name,c.id] }
    end
    
  end
end
