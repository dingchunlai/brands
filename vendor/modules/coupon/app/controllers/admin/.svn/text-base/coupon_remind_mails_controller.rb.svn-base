# encoding: utf-8
require_dependency 'coupon/admin_controller'
class Admin::CouponRemindMailsController < Coupon::AdminController

  load_and_authorize_resource
  
  def index
    @coupon_remind_mails = CouponRemindMail.paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @coupon_remind_mail = CouponRemindMail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @coupon_remind_mail = CouponRemindMail.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @coupon_remind_mail = CouponRemindMail.find(params[:id])
  end

  def create
    @coupon_remind_mail = CouponRemindMail.new(params[:coupon_remind_mail])

    respond_to do |format|
      if @coupon_remind_mail.save
        flash[:notice] = 'CouponRemindMail was successfully created.'
        format.html { redirect_to(admin_coupon_remind_mails_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @coupon_remind_mail = CouponRemindMail.find(params[:id])

    respond_to do |format|
      if @coupon_remind_mail.update_attributes(params[:coupon_remind_mail])
        flash[:notice] = 'CouponRemindMail was successfully updated.'
        format.html { redirect_to(admin_coupon_remind_mail_path(@coupon_remind_mail)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
#    @coupon_remind_mail = CouponRemindMail.find(params[:id])
#    @coupon_remind_mail.update_attributes(:deleted => true)
    respond_to do |format|
      format.html { redirect_to(admin_coupon_remind_mails_path) }
    end
  end

end
