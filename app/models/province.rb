# encoding: utf-8
# Add For Coupon
class Province < ActiveRecord::Base
  include Hejia::Location

  has_many :cities
  has_many :location_relate_model, :as => :resource
  
  validates_presence_of :name, :pinyin, :code_name

  default_scope :conditions => { :deleted => false }
  
  #得到和模块关联的省份
  named_scope :get_province_for_model ,lambda{ |model_name| 
    {
      :joins => "join location_relate_models  on provinces.id = location_relate_models.resource_id and location_relate_models.resource_type = 'Province'",
      :conditions => ["location_relate_models.model_name = ? " , model_name]
    }
  }
    
  REGION = {
    "华中" => ["河南", "湖北", "湖南"],
    "华东" => ["安徽 ", "江苏", "江西", "上海", "浙江"],
    "华南" => ["福建", "广西", "广东", "海南", "云南"],
    "华西" => ["贵州", "四川", "重庆"],
    "华北" => ["河北", "北京", "山东", "山西"],
    "东北" => ["黑龙江", "辽宁", "吉林"],
    "西北" => ["甘肃 ", "内蒙", "宁夏", "青海", "陕西", "新疆"]
  }
  
  # 返回省份对应的地区的hash
  def self.region_for_province
    REGION.inject({}) do |h, (region, provinces)|
      provinces.each { |province| h[province] = region }
      h
    end
  end
  
  #多乐士省份调用
  def self.get_province_douleshi
    Province.get_province_for_model("多乐士").all(:without_whole => true)
  end

  # 金刷子省份调用
  def self.get_province_jinshuazi
    Province.get_province_for_model("金刷子").all(:without_whole => true)
  end
  
  # 根据城市得到具体城市信息
  # 此方法的添加是因为 paint_ 那边JS调用还在使用
  def self.inferiors_of(pro_code)
     find_by_pinyin(pro_code).cities.map{|p| [p.pinyin, p.name]}
  end

  # 省份删除
  def mark_deleted
    if update_attributes(:deleted => true)
      self.cities.each do |city|
        city.mark_deleted
      end
    end
  end
end
