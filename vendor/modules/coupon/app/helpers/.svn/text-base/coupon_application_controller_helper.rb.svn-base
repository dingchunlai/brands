module CouponApplicationControllerHelper

  # 设置coupon前台页面的SEO信息
  def set_coupon_page_meta_data(title='', keywords='', descritpion='', city_name = @city && @city.name || '上海')
    title = "【无条件现金抵用券】#{city_name}装修建材优惠券,家装产品购买现金抵用券_和家网装修省钱狂频道" if title.blank?
    keywords = "优惠券,抵用券,代金券,折扣券,装修,建材,装修省钱狂,无条件现金抵用券" if keywords.blank?
    descritpion = "和家网无条件现金抵用券,覆盖油漆涂料、厨房电器、地板、卫浴洁具、橱柜厨具、水处理、中央空调、家具、吊顶、瓷砖、门窗、壁纸、背景墙、照明灯具、装修辅材、五金、楼梯、采暖、家电、智能家居、布艺软、装饰品、装修公司等行业,聚合家居建材品牌,集优惠券、代金券、折扣券全部功能,为装修消费者提供代金优惠服务,目前已开通上海、南京、无锡、苏州、杭州、宁波6个城市。装修省钱,尽在和家网装修省钱狂频道。" if descritpion.blank?
    set_page_title(title)
    set_page_meta_keywords(keywords)
    set_page_meta_desc(descritpion)
  end

  def coupon_searh_explain
    @coupon_searh_explain ||= "和家网为您提供，#{Tag.categories_size}大行业#{Coupon.human_name}，请输入关键词"
  end

  def market_options_limit
    case @city.name
    when '上海'
      16
    when '南京'
      12
    when '宁波'
      13
    else
      12
    end
  end

end
