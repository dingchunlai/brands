# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def production_category_check_box_tags(coupon)
    production_category_ids = coupon.production_categories.map{|pc| pc.id.to_i}
    a = []
    coupon.category_options.each do |pc|
      a << check_box_tag('production_category_ids[]', pc[1], production_category_ids.include?(pc[1].to_i)) + pc[0]
    end
    a.length > 0 ? a.join(' ') : '请先选择行业与品牌'
  end
  
end
