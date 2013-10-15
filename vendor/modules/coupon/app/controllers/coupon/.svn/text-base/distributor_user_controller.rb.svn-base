require_dependency 'coupon'

class Coupon::DistributorUserController < ::PrettyAdminController
  set_navigation_partial 'shared/coupon/distributor_menu'
  set_menu_partial 'sub_menu'

  # before_filter :authenticate
  before_filter :login_auth

  # 针对抵用卷后台
  # 无权限跳至抵用卷后台首页
  rescue_from CanCan::AccessDenied do |exception|
    flash[:permission_denied] = "访问限制: 您没有相应的操作权限."
    session[:last_request_uri] = request.request_uri
    redirect_to distributor_user_index_path
  end


  # 登录验证信息
  def login_auth
    if current_ability_user
      distributor = current_ability_user.distributors.first
      unless distributor
        logout_user!
        flash[:session_expired] = '帐号关联错误!'
        redirect_to(distributor_user_login_path)
        return
      end
      @current_distributor = distributor
    else
      flash[:session_expired] = '会话已过期,请重新登录!'
      redirect_to(distributor_user_login_path)
    end
  end

end
