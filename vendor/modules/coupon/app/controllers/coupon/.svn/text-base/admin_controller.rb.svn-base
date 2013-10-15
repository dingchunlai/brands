#require_dependency 'coupon'

class Coupon::AdminController < ::PrettyAdminController
  set_navigation_partial 'shared/coupon/admin_menu'
  set_menu_partial 'sub_menu'

  # before_filter :authenticate
  before_filter :login_auth

  # 针对抵用卷后台
  # 无权限跳至抵用卷后台首页
  rescue_from CanCan::AccessDenied do |exception|
    flash[:permission_denied] = "访问限制: 您没有相应的操作权限."
    session[:last_request_uri] = request.request_uri
    redirect_to coupon_admin_index_path
  end


  # 登录验证信息
  def login_auth
    unless current_ability_user
      flash[:session_expired] = '会话已过期,请重新登录!'
      redirect_to(coupon_admin_login_path)
    end
  end

end
