class PaintSessionsController < PaintApplicationController
  
  skip_filter :auto_expire, :only => [:login_show] 
  
  def index
    render :layout =>  false
  end 

  def forgot_password
    render :layout =>  false
  end

  
  def logout
    logout_user!
    redirect_to root_path
  end
 
 #因整个页面做的缓存，所以按钮显示用JS控制
 #params[:front_or_backend] 是判断路由是前台还是会员后台
   def login_show
     if paint_worder_loggin?
        if params[:front_or_backend] == "front_end"
          render :partial => 'layout_index_button'
        else
          render :partial => 'layout_logout_button'
        end
     else
        render :partial => 'layout_login_button'
     end
  end
    
  def validate_username
    username = HejiaUserBbs.find_by_USERNAME(params[:user_name])
    if username.nil?
      render :json=> true.to_json 
    else
      render :json=> false.to_json 
    end
  end
  def validate_phone
    username = HejiaUserBbs.find_by_USERBBSMOBELTELEPHONE(params[:user_phone])
    if username.nil?
      render :json=> true.to_json 
    else
      render :json=> false.to_json 
    end
  end
end
