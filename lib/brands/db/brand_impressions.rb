require 'yaml'


# add Impresessions
module Brands
  module DB
    class BrandImpressions
      def self.load_data_form_yml(yml)
       YAML.load(yml).each do |tag_name, item|
         tag = Tag.categories.find_by_TAGNAME tag_name
         item.each do |name_zh, item|
           brand = Brand.find_by_name_zh name_zh
           item.each do |impre|
              tagged_brand = TaggedBrand.find_by_tag_id_and_brand_id(tag.TAGID, brand.id)
              unless tagged_brand.blank?
                Impression.create({:tagged_brand_id => tagged_brand.id, :title => impre[0], :number => impre[1]})
              end
           end
         end
       end
      end
    end
  end
end
