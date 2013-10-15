require 'singleton'


module Brands
  module DB
    class BrandPromotionCode
      include Singleton
      def run!
        {
          'youqituliao' => ['huarun', 'carpoly'],
          'weiyu' => ['roca', 'americanstandard'],
          'chufangdianqi' => ['fotile', 'dandy'],
          'kongtiao' => ['gree'],
          'shuichuli' => ['paragonwater'],
          'diban' => ['nature', 'powerdekor']
        }.each do |tagurl,  brands|
          tag = Tag.find_by_TAGURL tagurl
          brands.each do |permalink|
            brand = Brand.find_by_permalink permalink
            unless brand.blank?
              ['焦点新闻', '俱乐部', '测评导购', '优惠促销活动', '热门标签'].each do |fouse|
                PromotionCollection.create(
                  :name => "品牌库品牌首页#{tag.TAGNAME}#{brand.name_zh}#{fouse}",
                  :code => "品牌库:品牌首页:#{tag.TAGURL}:#{brand.permalink}:#{fouse}",
                  :item_type => "GeneralResource"
                )
              end
            end
          end
        end
      end
    end
  end
end
