class PaintAdmin::AdminController < PrettyAdminController
  
  rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = exception.message
      redirect_to paint_admin_root_path
    end
  
  before_filter :login_required
  
  set_navigation_partial "/shared/paint_admin_menu"
  
private

  def login_required
    if user_logged_in?
      admin = PaintAdmin.find_by_USERBBSID current_user.id
      if admin.nil?
        flash[:error] = "请登录"
        redirect_to paint_admin_root_path
      end
    else
      flash[:error] = "请登录"
      redirect_to paint_admin_root_path
    end
  end
  
end