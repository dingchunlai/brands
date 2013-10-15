# encoding: utf-8

# Front_Page coupon_controller

class CouponThematicesController < CouponApplicationControllerController
  # include ActionView::Helpers::DateHelper

  before_filter :validate_top_city,  :only => [:second_killing]  #验证是否为上海
  caches_action :second_killing, :expires_in => 5.minutes

  def second_killing

  end

  private
  def validate_top_city
    unless @city.pinyin == 'shanghai'
      page_not_found!
      false
    end
  end

end
