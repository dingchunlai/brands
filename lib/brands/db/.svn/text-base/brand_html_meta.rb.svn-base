require 'yaml'

module Brands
  module DB
    class BrandHtmlMeta
      def self.load_data_form_yml(yml)
        YAML.load(yml).each do |tag_name, brands|
          tag = Tag.categories.find_by_TAGNAME tag_name
          # 判断品类是否存在
          unless tag.blank?
            brands.each do |name, html_items|
              brand = Brand.find_by_name_zh name
              # 判断品牌是否存在
              unless brand.blank?
                html_items.each do |item|
                  url = "http://#{tag.TAGURL}.51hejia.com/#{brand.permalink}"
                  html = HtmlMetadata.find_by_url url
                  html = HtmlMetadata.new if html.nil?
                  html.url = url
                  html.title = item["title"]
                  html.keywords = item["keywords"]
                  html.description = item["description"]
                  html.save
                end
              end
            end
          end
        end
      end
    end
  end
end
