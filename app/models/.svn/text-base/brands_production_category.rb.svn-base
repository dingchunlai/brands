class BrandsProductionCategory < ActiveRecord::Base
  
  belongs_to :production_category
  belongs_to :brand

  # 获取某品牌下的所有品类信息
  named_scope :for_brand, lambda { |brand_id|
    { :conditions => ["brand_id = ?", brand_id] }
  }

  # 获取某品类下的所有品牌信息
  named_scope :for_production_category, lambda { |production_category_id|
    { :conditions => ["production_category_id = ?", production_category_id] }
  }

end
