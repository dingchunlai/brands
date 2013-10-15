# 品牌库页面 
# 排除品牌 || 品类页面的其他页面
class IndexPage < PromotionPage
  
  self.page_name = "品牌库"
  
  class << self
    # 推广页面, 品类，品牌，推广项
    def item_code(name, item_name)
      "#{page_name}:#{name}:#{item_name}"
    end
  end
 
  # 对外公开类方法
  def item_code(name, item)
    self.class.item_code(name, item)
  end
  
  # 创建推广项
  def create_promotion_item(name)
    promotion_page_parts.each do |item|
      code = item_code(name, item.name)
      promotion_item = PromotionCollection.find_by_code(code)
      if promotion_item.nil?
        PromotionCollection.create(
          :name => item_code(name, item.name).gsub(':', ''),
          :code => code,
          :item_type => item.item_type
        )
      end
    end
  end

  def collection_item(name, item_name)
    PromotionCollection.find_by_code(item_code(name, item_name))
  end
end
