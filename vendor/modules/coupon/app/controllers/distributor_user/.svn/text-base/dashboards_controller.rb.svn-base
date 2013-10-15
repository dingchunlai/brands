# encoding: utf-8
require_dependency 'coupon'
class DistributorUser::DashboardsController < Coupon::DistributorUserController
  
  def index
    @coupons_count = ::Coupon.count(:conditions => ["distributor_id = ?", @current_distributor.id])
    @shops_count = Distributor::Shop.count(:conditions => ["distributor_id = ?", @current_distributor.id])
    respond_to do |format|
      format.html { }
    end
  end

  # modify password
  def changepwd
    respond_to do |format|
      format.html { }
    end
  end

  # modify password
  def create
    if params[:account] and params[:account][:password] and params[:account][:password_confirmation]
      if params[:account][:password] != params[:account][:password_confirmation]
        respond_to do |format|
          format.html { redirect_to :back, :notice => "两次输入的密码不一致！" }
        end
      else
        respond_to do |format|
          if current_ability_user.update_attributes(:USERSPASSWORD => params[:account][:password])
            format.html { redirect_to :back, :notice => '密码成功修改，下次登录请使用新密码!' }
          else
            format.html { redirect_to :back, :notice => '密码修改失败，请联系我们的工作人员!' }
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, :notice => "unkown request!" }
      end
    end
  end

end