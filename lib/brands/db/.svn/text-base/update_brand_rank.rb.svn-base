require 'singleton'

module Brands
  module DB
    class UpdateBrandRank
      include Singleton

      def run!
        # 弥补上次导致的错误数据 
        # 四个品牌信息需要修改 依次为：油漆涂料:42093，厨房电器:42096， 地板:42099， 卫浴:42100
        # 到目前为止一共修改上月数据为5个品类 + 中央空调
        [42093, 42096, 42099, 42100].each do |tag_id|
          update(tag_id)
        end
      end
      
      # 此处可以传time月份进去，
      # 本次主要修改月份2010年8月分，即默认值201008
      def update(tag_id)
        tagged_brands = TaggedBrand.find(:all, :conditions => ["tag_id = ?", tag_id])
        tagged_brands.each do |tb|
          tb.brand.update_error_rank(tag_id) unless tb.brand.blank?
        end
      end

    end
  end
end
