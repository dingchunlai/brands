module Dianping::CouponsHelper

  # 优惠卷和现金劵将通用一个页面只是连接地址不一样
  def location_second_name(action_name)
    action_name == 'show' ? "优惠劵 #{@event.title}" : "抵用劵 #{@coupon.title}"
  end

end
