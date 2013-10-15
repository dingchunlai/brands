require 'yaml'

module Brands
  module DB
    class BrandVotes
      def self.load_data_form_yml(yml)
        YAML.load(yml).each do |tag_name, item|
          tag = Tag.categories.find_by_TAGNAME tag_name
          unless tag.blank?
            item.each do |brand_name, data|
              brand = Brand.find_by_name_zh brand_name
              unless brand.blank?
                tagged_brand = TaggedBrand.find_by_tag_id_and_brand_id(tag.TAGID, brand.id)
                data.each_with_index do |value, index|
                  attr = TaggedBrand.vote_items[index.to_i]
                  case index.to_i
                  when 0:
                    tagged_brand.vote_for(attr, value['计划购买'])
                  when 1:
                    tagged_brand.vote_for(attr, value['强烈关注'])
                  when 2:
                    tagged_brand.vote_for(attr, value['有点兴趣'])
                  when 3:
                    tagged_brand.vote_for(attr, value['随便看看'])
                  when 4:
                    tagged_brand.vote_for(attr, value['没有兴趣'])
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
