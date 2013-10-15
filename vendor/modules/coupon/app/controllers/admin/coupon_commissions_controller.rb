# -*- encoding: utf-8 -*-
require_dependency 'coupon/admin_controller'
class Admin::CouponCommissionsController < Coupon::AdminController
  load_and_authorize_resource
  
  def index
    @coupon = Coupon.find(params[:coupon_id])
    # 过期不可设置佣金
    if @coupon.activity_end_at.to_date < Time.zone.today
      render :text => <<-CODE_JS
    <script type='text/javascript'>
    alert("该抵用券已经过期，不可设置佣金!\\n点[确定]返回抵用券列表页！");
    location.href='#{admin_coupons_path}';
    </script>
      CODE_JS
      return
    end
    @coupon_commissions = @coupon.coupon_commissions.paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @coupon_commission = CouponCommission.find(params[:id])
    @coupon = Coupon.find(@coupon_commission.coupon_id) 
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @coupon = Coupon.find(params[:coupon_id])
    if @coupon.activity_end_at.to_date < Time.zone.today
      render :text => <<-CODE_JS
    <script type='text/javascript'>
    alert("该抵用券已经过期，不可设置佣金!\\n点[确定]返回抵用券列表页！");
    location.href='#{admin_coupons_path}';
    </script>
      CODE_JS
      return
    end
    @coupon_commission = @coupon.coupon_commissions.new

    respond_to do |format|
      format.html # new.html.erbe
    end
  end

  def edit
    @coupon_commission = CouponCommission.find(params[:id])
    if @coupon_commission.activity_in.beginning_of_month <= Time.zone.today.beginning_of_month
      render :text => <<-CODE_JS
    <script type='text/javascript'>
    alert("该佣金记录信息不可编辑\\n\\n原因如下:\\n\\n\\t佣金月份小于（含等于）当前操作月份！\\n\\n点 [确定] 返回对应抵用券佣金列表页!");
    location.href='#{admin_coupon_commissions_path(:coupon_id => @coupon_commission.coupon_id)}';
    </script>
      CODE_JS
      return
    end
    @coupon = Coupon.find(@coupon_commission.coupon_id)
  end

  def create
    @coupon_commission = CouponCommission.new(params[:coupon_commission])

    respond_to do |format|
      if @coupon_commission.save
#        flash[:notice] = 'CouponCommission was successfully created.'
        format.html { redirect_to(admin_coupon_commissions_path(:coupon_id => @coupon_commission.coupon_id)) }
      else
        @coupon = @coupon_commission.coupon
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @coupon_commission = CouponCommission.find(params[:id])

    respond_to do |format|
      if @coupon_commission.update_attributes(params[:coupon_commission])
#        flash[:notice] = 'CouponCommission was successfully updated.'
        format.html { redirect_to(admin_coupon_commission_path(@coupon_commission)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    redirect_to(admin_coupon_commissions_path)
#    @coupon_commission = CouponCommission.find(params[:id])
#    @coupon_commission.mark_deleted
#    @coupon_commission.update_attributes(:deleted => true)
#    respond_to do |format|
#      format.html { redirect_to(admin_coupon_commissions_path) }
#    end
  end

end
