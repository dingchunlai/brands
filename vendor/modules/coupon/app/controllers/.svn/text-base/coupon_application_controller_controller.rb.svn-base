# encoding: uft-8

# Front Controller Inheritance Controller
# Used for the front filter [subdomain]

require_dependency 'coupon/admin_controller'
class CouponApplicationControllerController < AutoExpireController
  include IpHelper
  layout "shared/layouts/coupon" 
  before_filter :validate_domain
  before_filter :set_seo_source

  # 验证域名，获取城市信息
  def validate_domain
    # 当一级域名为 youhui
    if current_subdomain.split(".").size == 1
      if current_subdomain == 'youhui'
        # 下面是根据IP取得城市
        remote_location = ChunzhenIp.default.find_location_by_ip request.remote_ip
        code = remote_location && remote_location.city && remote_location.city.to_pinyin || 'shanghai'
        @city = City.with_pinyin(code)[0]
        redirect_to "http://#{@city.pinyin}.youhui.51hejia.com"
      else
        head 404
      end
    # 当输入有二级域名时
    elsif current_subdomain.split(".").size == 2
      if current_subdomain.split(".")[1] == 'youhui'
        city = current_subdomain.split(".")[0]
        @city = (City.with_pinyin(city).blank? ? nil : City.with_pinyin(city)[0])
        if @city.blank?
          head 404
        end
      else
        head 404
      end
    else
      head 404
    end
  end


  # 验证某个抵用是否处于正常状态
  # status[1] 属于正常正常状态
  def validate_coupon_status
    @coupon = Coupon.find :first, :conditions => ["id = ? and status = ? and deleted = ?", params[:id], 1, false]
    if @coupon.blank?
      head 404
    end
  end

  private 
    def set_seo_source
      cookies[:cp_source] = {:domain => '.youhui.51hejia.com', :value => params[:source], :path => '/'} if params[:source]
    end

end
