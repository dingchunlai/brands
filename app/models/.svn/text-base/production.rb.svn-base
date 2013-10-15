class Production < ActiveRecord::Base
  alias_attribute :tag, :brand_category

  belongs_to :brand
  belongs_to :brand_category, :class_name => 'Tag'
  belongs_to :category,       :class_name => 'ProductionCategory', :foreign_key => 'category_id'
  belongs_to :series,         :class_name => 'ProductionSeries'
  belongs_to :production_promotion_info, :primary_key => 'production_id', :foreign_key => 'id'
  
  has_one :master_picture_paint, :class_name => 'CloudPicture', :conditions => "is_master = 1", :as => :item
  has_one :master_picture, :class_name => 'ProductPicture', :as => :attachable, :conditions => {:is_master => 1}
  # 取得某个产品的附图的一张
  has_one :not_master_picture, :as => :attachable, :class_name => 'ProductPicture', :conditions => ["is_master = 0"], :order => 'id DESC'

  has_many :pictures,   :class_name => 'ProductPicture', :as => :attachable, :dependent => :destroy
  has_many :properties, :class_name => 'ProductionProperty', :dependent => :destroy
  has_many :attrs,      :through => :category

  validates_presence_of :name
  validates_presence_of :brand_id
  validates_presence_of :category_id
  validates_presence_of :brand_category_id

  #取得推广类型取得产品记录
    def self.get_production_by_promotion_info(limit, priority_type, brand_category_id, brand_id,c_id=nil)
      conditions = []
      conditions << "pro.is_valid = 1"
      conditions << "ppi.#{priority_type} > 0"
      conditions << "pro.brand_category_id = #{brand_category_id}" if brand_category_id.to_i > 0
      conditions << "pro.brand_id = #{brand_id}" if brand_id.to_i > 0
      conditions << "pro.category_id = #{c_id}" if c_id
      Production.find(:all,:select=>"pro.*",
        :joins=>"pro inner join production_promotion_info ppi on ppi.production_id=pro.id",
        :conditions=>conditions.join(" and "),
        :order=>"ppi.#{priority_type} asc",
        :limit=>limit)
    end
  
  # 根据品牌编号和品类编号查找出所有产品
  def self.production_categorys(brand_id,category_id)
    productions = Production.find(:all,:conditions => ["brand_id = ? and brand_category_id =?",brand_id,category_id],:group => "category_id")
    if productions
      ids = productions.collect{|p| p.category_id}
      category = ProductionCategory.find(:all,:conditions => ["id in (?)",ids])
    else
      category = nil
    end
    return category
  end
  
  
  named_scope :by_create_date,:conditions => "created_at > '2009-01-01 00:00:00'"
  
  
  # 根据品牌和品类编号查询获取产品
  # params[:tag] 品类对象或者品类编号
  # params[:brand] 品牌对象或者品牌编号
  # return production collection
  named_scope :of_brand_tag, lambda { |brand_id, tag_id|
    tag_id      = tag_id.TAGID if tag_id.is_a?(Tag)
    brand_id    = brand_id.id if brand_id.is_a?(Brand)
    {
      :conditions => ["brand_id = ? and brand_category_id = ?", brand_id, tag_id]
    }
  }
  
  named_scope :for_limit, lambda{|limit|{:limit => limit}}

  named_scope :for_category,lambda { |c| {:conditions =>["category_id = ?",c]} }
end
