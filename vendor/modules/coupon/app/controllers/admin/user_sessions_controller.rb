class Admin::UserSessionsController < ApplicationController
  layout false

  def new
    flash[:notice] = "" 
  end

  def create
    #render :text => "暂未开放"
    user = nil
    if params[:account][:login_type] == "1"
      user = RadminUser.first(:conditions => ["name = ? and pw_md5 = ?", params[:account][:name], Digest::MD5.hexdigest(params[:account][:password])])       
    else
      user = DistributorAccount.first(:conditions => ["USERNAME = ? and USERSPASSWORD = ?", params[:account][:name], DistributorAccount.md5(params[:account][:password])])
    end
    respond_to do |format|
      if user
        if params[:account][:login_type] == "1"
          # 后台登录
          login_staff!(user)
          roles = user.role.to_s.split(",").map! &:to_i
          # 判断是否数据经销商用户角色
          if roles.include?(115) || roles.include?(148) || roles.include?(147) || roles.include?(146) || roles.include?(145) || roles.include?(144)   
            flash[:notice] = ""
            format.html { redirect_to(coupon_admin_index_path) }
          else
            flash[:notice] = "此用户无此权限 ! "
            format.html { render :action => "new" }
          end
        else
          # 经销商用户
          login_user!(user)
          format.html { redirect_to(coupon_admin_index_path) }
        end
       else
        flash[:notice] = "用户名或密码错误!(提示：注意选择登录类型)"
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    logout_user!
    logout_staff!
    redirect_to(coupon_admin_login_path)
  end  
end
