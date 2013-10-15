require 'yaml'


module Brands
  module DB
    class LoadRatings
      # yaml format
      # 2010-07-12:
      #     厨房电器:
      #           方太: 221
      #           老板: 441
      # 2010-07-13:
      #         卫浴:
      #           和成: 114
      #           箭牌: 552
      #         ............
      def self.load_data_form_yml(yml)
        YAML.load(yml).each do |data, item|
          item.each do |tag, brand|
            tag = Tag.categories.find_by_TAGNAME tag
            brand.each do |key, value|
              brand = Brand.find(:first, :conditions => ["name_zh = ?", key])
              brand.increase_pv!(tag.TAGID, :when => data, :n => value)
            end
          end
        end
      end
    end
  end
end
