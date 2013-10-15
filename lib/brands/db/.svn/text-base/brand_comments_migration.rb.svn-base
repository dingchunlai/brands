require 'singleton'

# 创建原有存贮品类信息的model
class ProductCategory < ActiveRecord::Base
  set_table_name 'product_categories'
  set_primary_key 'id'
end


# 基于原有的查询条件提取评论信息
# formid = 83 and isdelete = 0 and c33 = 1 and c23 = 1 and c21 = brand_id and c34 = category_id
module  Brands
  module  DB
    class BrandCommentsMigration
      include Singleton
      
      def run!
        Comment.all(:conditions => ["formid = 83 and isdelete = 0 and c33 = 1 and c23 = 1"]).each do |comment|
          category = tag_id(comment.c34)
          if category != nil
            # 查询原则，在品牌库下面的品类中和和原有的C34对应的品类名称进行查询。有则返回对象 ||  无则返回nil
            tag =  Tag.categories.first(:conditions => ["HEJIA_TAG.TAGNAME = ?", category.name_zh])
            tagid = tag ? tag.TAGID : nil
          else
            tagid = nil
          end
          next if tagid.nil?
          # 修改原评论的  c34 （存贮品类编号） 属性
          comment.update_attribute("c34", tagid)
        end
      end
      # 此方法传进来一个原有品类的编号
      # 根据原有编号找出他的名称；然后在HEJIA_TAG中再根据名称寻找出处于品牌库出下同名的品类编号
      # 如果找到则返回品类的编号  ||  找不到则返回一个nil
      def tag_id(c34)
        begin
          ProductCategory.find c34
        rescue
          nil
        end
      end
    end
  end
end