class HomePageRedirectController < ActionController::Base
  include IpHelper
  def index
    city =  remote_city[:name]
    case city
    when "无锡" ; redirect_to "http://z.wuxi.51hejia.com"
    when "杭州" ; redirect_to "http://z.hangzhou.51hejia.com"
    else redirect_to "http://www.51hejia.com/index"
    end
  end

end

