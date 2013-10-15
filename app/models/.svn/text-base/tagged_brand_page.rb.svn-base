# 品牌页面
class TaggedBrandPage < PromotionPage
  
  self.page_name = "品牌页"
  
  class << self
    # 推广页面, 品类，品牌，推广项
    def item_code(name, tag, brand, item_name)
      "品牌库:#{page_name}:#{name}:#{tag}:#{brand}:#{item_name}"
    end
  end
 
  # 对外公开类方法
  def item_code(name, tag, brand, item)
    self.class.item_code(name, tag, brand, item)
  end
  
  # 创建推广项
  def create_promotion_item(name, tag, brand)
    promotion_page_parts.each do |item|
      code = item_code(name, tag.TAGURL, brand.permalink, item.name)
      promotion_item = PromotionCollection.find_by_code(code)
      if promotion_item.nil?
        PromotionCollection.create(
          :name => item_code(name, tag.TAGNAME, brand.name_zh, item.name).gsub(':', ''),
          :code => code,
          :item_type => item.item_type
        )
      end
    end
  end

  def collection_item(name, tag, brand, item_name)
    PromotionCollection.find_by_code(item_code(name, tag, brand, item_name))
  end
end
