# encoding: utf-8

class CouponCell < ApplicationCell

  #cache :my_coupons
  include CouponsHelper

  def my_coupons
    @my_coupons = []    #Coupon.by_ids(@opts[:my_coupons_ids])
    render
  end

  # 热门抵用卷
  # params[:city_id] 
  # params[:limit]
  def hot_coupons
    @hot_coupons =  
      @opts[:tag_id].to_i == 0 ? Coupon.order_down.with_city(@opts[:city_id]).first(@opts[:limit]) : Coupon.with_tag_city(@opts[:tag_id], @opts[:city_id], @opts[:limit])
    render
  end

  # 本周下载排行榜
  # params[:tag_id]
  def one_week_top
    count, all_tags = 3, Industry.all_categories
    @three_tags = 
      @opts[:tag_id].to_i == 0 ? all_tags.first(count) : Industry.find_by_TAGID(tag_id).to_a + all_tags.first(count)
    @three_tags.uniq.first(count)
    render
  end

  # 您最近浏览过的抵用卷
  def owned_browsed_coupons
    # => :ids = cookies[:browsed_coupons]
    @browsed_coupons = @opts[:browsed_coupons].blank? ? [] : Coupon.find(@opts[:browsed_coupons].split(',')).to_a
      
    render
  end

  # 您可能感兴趣的抵用卷
  # params[:city_id]
  # params[:limit]
  def interested_coupons
    @interested_coupons = Coupon.with_city_new(@opts[:city_id], @opts[:limit])
    render
  end

end
