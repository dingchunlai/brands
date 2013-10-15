# encoding: utf-8

# Front CouponComplaint_Controller

class ComplaintsController < CouponApplicationControllerController

  before_filter :validate_coupon_status, :only => [:new]

  def new
    @distributor = Distributor.find(@coupon.distributor_id)
    @shop = Distributor::Shop.find(@coupon.shop_id)
    @complaint = @coupon.complaints.new(:coupon_code => @coupon.code)
  end

  def create
    # 先行处理掉session
    if session[:image_code] != params[:image_code]
      respond_to do |format|
        format.html {
          redirect_to(new_complaint_path(:id => params[:complaint][:coupon_id]))
        }
        format.js {
          render :update do |page|
            page << "$('#msg_for_image_code').text('请填写正确的验证码');\n$('#msg_for_image_code').addClass('djq_alert');"
          end
        }
      end
      return
    end
    @complaint = Coupon.find(params[:complaint][:coupon_id]).complaints.new(params[:complaint])
    
    respond_to do |format|
      if @complaint.save
        format.html { redirect_to(coupon_show_path(@complaint.coupon)) }
        format.js {}
      else
        format.html {
          @coupon = Coupon.find(@complaint.coupon_id)
          @distributor = Distributor.find(@coupon.distributor_id)
          @shop = Distributor::Shop.find(@coupon.shop_id)
          render :action => "new"
        }
        format.js {}
      end
    end
  end

end
