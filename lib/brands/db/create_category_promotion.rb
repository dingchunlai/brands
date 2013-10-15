# add Impresessions
module Brands
  module DB
    class CreateCategoryPromotion 
      def self.filter_params(tag, category, brand)
        obj_tag = Tag.find_by_TAGNAME tag, :select => 'TAGURL, TAGNAME'
        obj_category = ProductionCategory.find_by_name category, :select => 'name'
        obj_brand = Brand.find_by_name_zh brand, :select => 'name_zh, permalink'
        
        if obj_tag.blank? || obj_category.blank? || obj_brand.blank?
          p '行业 ｜ 品类 ｜ 品牌 其中一个没有找到对应的数据'
        else
          items = {'图片切换' => 6, '热推' => 1, '活动' => 2, '新闻' => 3, '导购' => 3, '应用案例' => 4, '产品推荐' => 3, '热品推荐' => 3, '热水问题' => 4, '产品评测' => 3, '电气' => 1, '燃气' => 1, '其它' => 1, '视频展示' => 3, '小贴士' => 4, '网友日记' => 5, '头部图片' => 1, '右上图片' => 1 }

          items.each do |key, value|
            PromotionCollection.create(:name => "#{obj_tag.TAGNAME}#{obj_brand.name_zh}#{obj_category.name}#{key}",
                  :code => "品牌库:二级分类:#{obj_tag.TAGURL}:#{obj_category.name}:#{obj_brand.permalink}:#{key}",
                  :item_type => 'GeneralResource',
                  :size => value
                ) 
          end
        end
      end
    end
  end
end
