require 'yaml'


module Brands
  module DB
    class BrandComments
      def self.load_data_form_yml(yml, is_good)
        users = HejiaUserBbs.find(:all, 
                         :select => "USERBBSID, USERNAME", 
                         :conditions => ["USERNAME is not null and freeze_date is null"], 
                         :order => "USERBBSID DESC", 
                         :limit => 100)
        YAML.load(yml).each do |tag_name, item|
          tag = Tag.categories.find_by_TAGNAME tag_name
          unless tag.blank?
            item.each do |brand_name, data|
              brand = Brand.find_by_name_zh brand_name
              tagged_brand = TaggedBrand.find_by_tag_id_and_brand_id(tag.TAGID, brand.id)
              unless tagged_brand.blank?
                data.each do |com|
                  user = users[rand(100)]
                  Comment.create(
                    :remark => (is_good ? [3, 4].rand : [0, 1].rand),
                    :tagged_brand_id => tagged_brand.id,
                    :body => com['内容'],
                    :title => com['标题'],
                    :user_id => user.USERBBSID,
                    :user_name => user.USERNAME,
                    :tags => com['标签']
                  )
                end
              end
            end
          end
        end
      end
    end
  end
end
