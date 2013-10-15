# encoding: utf-8
# Add For Coupon
class ProductionCategory < ActiveRecord::Base

  has_many :productions, :dependent => :destroy, :foreign_key => 'category_id'
  # 不能使用attributes作为关系的名称，因为attributes是ActiveRecord::Base的方法。
  has_many :attrs, :class_name => 'ProductionAttribute', :foreign_key => 'category_id'
  has_many :brands_production_categories, :dependent => :destroy
  has_and_belongs_to_many :coupons
  belongs_to :tag

  include HejiaCouponSerializable
  hejia_set_serialization (1..9).to_a.concat(('a'..'z').to_a)

  after_create :serializable_code

  def serialization_key
    "hejia:coupon:tag_#{tag.code}:code"
  end

=begin
  has_and_belongs_to_many :attributes,
    :class_name => 'ProductionAttribute',
    :join_table => 'production_attributes_production_categories',
    :foreign_key => 'production_category_id',
    :association_foreign_key => 'production_attribute_id'
=end
  has_and_belongs_to_many :brands

  validates_presence_of   :name, :tag_id, :short_name
  validates_uniqueness_of :name, :short_name

  default_scope :order => 'priority'

  # 获取某行业下的所有行业
  named_scope :for_tag, lambda { |tag_id|
    { 
      :conditions => (tag_id.to_i == 0 ? nil : ["tag_id = ?", tag_id])
    }
  }

  # 获取某行业下的所有行业
  named_scope :with_name, lambda { |name|
    { 
      :conditions => (name.blank? ? nil : ["name LIKE ?", "%#{name}%"])
    }
  }


  # 链表查询某一品牌下的所有品类
  named_scope :for_brand, lambda { |brand_id|
    production_category_ids = BrandsProductionCategory.for_brand(brand_id).map{ |c| c.production_category_id }
    { :conditions => ["id in (?)", production_category_ids] }
  }
  
  named_scope :all_categories

  def serial_key
    "hejia:coupon:tag_#{tag.code}:code"
  end

  class << self

    def record_by_id(id)
      id.to_i > 0 ? self.first(:select => 'id, name', :conditions => ['id = ?', id]) : nil
    end

    def id_to_name(object)
      object = record_by_id(object) if object.class != self
      return '' if object.nil?
      object.name
    end

  end

  # 根据品类编号，品牌编号，品牌分类编号得到对应的产品信息
  def get_product_by_brand_category(brand_category_id, brand_id,category_id)
    return Production.find(:all, :conditions => ["brand_category_id = ? and brand_id = ? and category_id = ?",brand_category_id,brand_id,category_id])
  end

  # redis中取得一个序列字母填充到 code 中的
  def serializable_code
    unless tag.blank?
      update_attribute :code, next_success
    end
  end
  private :serializable_code

end
