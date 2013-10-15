class PaintAdmin::LoginController < PaintAdmin::AdminController
 
  skip_before_filter :login_required
 
  def index
    render :layout =>  false
  end
  
  def logout
    logout_user!
    redirect_to paint_admin_root_path
  end
  
end