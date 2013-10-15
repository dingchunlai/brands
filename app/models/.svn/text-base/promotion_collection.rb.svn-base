# 推广位
class PromotionCollection < ActiveRecord::Base

  # 推广条目
  has_many :items, :class_name => 'PromotionItem', :dependent => :destroy

  validates_presence_of :name

  named_scope :like_code_tagged_brand, lambda { |code| {
      :conditions => ["code LIKE ?", "%#{code}%"]
    }
  }
  

  class << self
    # 取得某一推广代号的所有有效推广内容。
    # @param [String] code 推广代号
    # @param [Boolean] published 是否只包含已发布的项目，默认：false。
    # @yield [item] 如果提供了block，就会对每一个推广内容调用一次block。
    # @yieldparam [Object] item 一条推广记录。
    def items_for(code, published = false)
      items = find(:first, :select => 'id, item_type, size', :conditions => {:code => code}).
              try(:items_with_resources, :published => published) || [] # 当推广位未创建的时候，也能正常使用
      items.each { |item| yield item } if block_given?
      items
    end
    alias all_items_for items_for # 兼容以前的名字

    # `items_for(code, true, &blk)`的一个简写。
    def published_items_for(code, &block)
      items_for code, true, &block
    end
  end

  # 所有推广条目，包括里面的资源。
  # 比如说，一个PromotionCollection推广的是Article。那么`items`方法返回的是推广的条目（优先级，发布日期等）；
  # 而`items_with_resources`所返回的推广条目好包括了resource，resouce是Article的一个对象。
  # @option options [Boolean] :force_reload
  # @option options [Boolean] :published
  def items_with_resources(options = nil)
    published_only = options.try(:[], :published)
    set_resources_for_items (published_only ? items.published : items(options.try(:[], :force_reload))).limit(published_only ? size : nil)
  end

  # items_with_resources(:published => true)的一个简写。
  # @param [Boolean] force_reload 是否强制读数据库，默认：false。
  def published_items_with_resources(force_reload = false)
    @published_items_with_resources = items_with_resources(:published => true) if @published_items_with_resources.nil? || force_reload
    @published_items_with_resources
  end

  def items_length
    PromotionItem.count("id", :conditions => ["promotion_collection_id = ?", id]).to_i
  end

  # 推广条目的Model
  def item_model
    @item_model ||= item_type.constantize
  end
  private :item_model

  def set_resources_for_items(items)
    model_pk = item_model.primary_key
    actual_items = item_model.find(
      :all,
      :conditions => ["#{model_pk} in (?)", items.map(&:resource_id)]
    )
    items.each { |item| item.resource = actual_items.detect { |actual| actual.send(model_pk) == item.resource_id } }
  end
  private :set_resources_for_items
  
end
