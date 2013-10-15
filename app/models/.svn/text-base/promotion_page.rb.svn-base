class PromotionPage <  ActiveRecord::Base

  has_many :promotion_page_parts, :as => :page

  class << self
    cattr_accessor :page_name
    cattr_accessor :item_code
  end

  MODEL_TYPE = {
    'IndexPage' => '品牌库',
    'TagPage' => '品类页', 
    'TaggedBrandPage' => '品牌页'
  }
  TYPE_NAME = MODEL_TYPE.inject({}) { |h, (k, v)| h[v] = k; h }.freeze

end
