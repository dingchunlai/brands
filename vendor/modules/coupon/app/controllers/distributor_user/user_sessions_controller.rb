class DistributorUser::UserSessionsController < ApplicationController
  layout false

  def new
    flash[:notice] = ""
  end

  def create
    user = DistributorAccount.first(:conditions => ["USERNAME = ? and USERSPASSWORD = ?", params[:account][:name], DistributorAccount.md5(params[:account][:password])])
    respond_to do |format|
      if user
        # 经销商用户
        login_user!(user)
        format.html { redirect_to(distributor_user_index_path) }
       else
        flash[:notice] = "帐号或密码错误!"
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
    logout_user!
    redirect_to(distributor_user_login_path)
  end
end
