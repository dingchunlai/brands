# 组合案例实体类
# 主要字段:id => 主键;  title => 标题;  content => 内容;  brand_id => 外键:品牌编号;   tag_id => 外键:品类编号 ;    pictrue_count => 图片记录数(暂时无用到)
# 其次关联多张图片信息
class ProductionCombination < ActiveRecord::Base
  belongs_to :brand
  belongs_to :tag
  
  has_one  :master_picture, :class_name => 'ProductPicture', :as => :attachable, :conditions => {:is_master => 1}
  has_many :pictures,       :class_name => 'ProductPicture', :as => :attachable, :dependent => :destroy

  validates_presence_of :title
  validates_presence_of :content

  # 根据标题进行模糊查询
  # @params[:title] 组合案例标题  String
  # @return combination 组合案例集合对象
  named_scope :with_title, lambda{|title|
    {
      :conditions => ['title LIKE ?',"%#{title}%"]
    }
  }
  # 根据品类编号查询
  # @params[:tag_id]  品类对象对象或者编号  Tag|Integer
  # @return combination 组合案例集合对象
  named_scope :with_tag, lambda{|tag_id|
    tag_id = tag_id.TAGID if tag_id.is_a?(Tag)
    {
      :conditions => ["tag_id = ?",tag_id]
    }
  }
  # 根据品牌编号进行查询
  # @params[:brand_id]  品牌对象或者品牌编号  Brand|Integer
  # @return combination 组合案例结合对象
  named_scope :with_brand, lambda{|brand_id|
    brand_id = brand_id.id if brand_id.is_a?(Brand)
    {
      :conditions => ["brand_id = ?",brand_id]
    }
  }

  def name; title end
end
