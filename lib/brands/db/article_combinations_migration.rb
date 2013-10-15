require 'singleton'

module Brands
  module DB
    class ArticleCombinationsMigration
      include Singleton
      
      def run!
        Article.all(:conditions => ["CHECK_BRAND = 5 and FIRSTCATEGORY = 42092"], :include => [:brand_link, :content]).each do |article|
          next if article.brand_link.blank?      #如果没有关联信息退出
          article.brand_link.each do |link|
            combination = ProductionCombination.new
            combination.brand_id  =   link.typeid
            combination.tag_id    =   link.firstid
            combination.title     =   article.TITLE
            combination.content   =   article.content.CONTENT
            combination.save!
          end
        end
      end
    end
  end
end