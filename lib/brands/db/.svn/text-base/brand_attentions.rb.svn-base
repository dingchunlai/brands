require 'singleton'

module Brands
  module DB
    class BrandAttentions
      include Singleton

      def run!(force)
        if force || (Time.now.day == 1)
          deal_with_pv
        end
      end

      def deal_with_pv
        TaggedBrand.all.each do |tagged_brand|
          tag = Tag.find_by_TAGID tagged_brand.tag_id
          unless tag.blank?
            brand = Brand.find_by_id tagged_brand.brand_id
            unless brand.blank?
              brand.recalculate_last_moth_pv(tag.TAGID)
            end
          end
        end
      end
    end
  end
end
