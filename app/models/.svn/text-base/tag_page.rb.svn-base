# 品类页面
class TagPage < PromotionPage

  self.page_name = "品类页"

  class << self
    # params[:name] 推广页面名称
    # params[:tag] TAGURL or TAGNAME
    # params[:item_name] 推广项名称
    def item_code(name, tag, item_name)
      "品牌库:#{page_name}:#{name}:#{tag}:#{item_name}"
    end
  end
  
  def item_code(name, tag, item_name)
    self.class.item_code(name, tag, item_name)
  end
  
  # 创建推广为代码
  def create_promotion_item(name, tag)
    promotion_page_parts.each do |item|
      code = item_code(name, tag.TAGURL, item.name)
      promotion_item = PromotionCollection.find_by_code(code)
      if promotion_item.nil?
        PromotionCollection.create(
          :name => item_code(name, tag.TAGNAME, item.name).gsub(':', ''),
          :code => code,
          :item_type => item.item_type
        )
      end
    end
  end

  def collection_item(name, tag, item_name)
    PromotionCollection.find_by_code(item_code(name, tag, item_name))
  end
end
