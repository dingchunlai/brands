# encoding: utf-8
require_dependency 'coupon/admin_controller'
class Admin::CouponIssueNumStatsController < Coupon::AdminController

  def index
    raise CanCan::AccessDenied unless can? :edit_existing_number, :coupons

    @coupon = Coupon.find(params[:coupon_id])
    
    @coupon_issue_num_stats = CouponIssueNumStat.paginate(
        :page => ((params[:page].to_i==0)? 1 : params[:page].to_i),
        :per_page => 20,
        :conditions => ["coupon_id = ?", @coupon.id],
        :order => 'id desc'
    )

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    raise CanCan::AccessDenied unless can? :edit_existing_number, :coupons

    @coupon = Coupon.find(params[:coupon_id])
    @coupon_issue_num_stat = CouponIssueNumStat.new(:coupon_id => @coupon.id)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    raise CanCan::AccessDenied unless can? :edit_existing_number, :coupons

    coupon = Coupon.find(params[:coupon_issue_num_stat][:coupon_id])
    @coupon_issue_num_stat = CouponIssueNumStat.new(params[:coupon_issue_num_stat])

    if @coupon_issue_num_stat.op_type == "add"
      coupon.total_issue_number += @coupon_issue_num_stat.counts
      coupon.existing_number += @coupon_issue_num_stat.counts
      coupon.virtual_existing_number += @coupon_issue_num_stat.counts
    elsif @coupon_issue_num_stat.op_type == "reduce"
      coupon.total_issue_number -= @coupon_issue_num_stat.counts
      coupon.existing_number -= @coupon_issue_num_stat.counts
      coupon.virtual_existing_number -= @coupon_issue_num_stat.counts
    else
      redirect_to(admin_coupon_issue_num_stats_path(:coupon_id => coupon.id))
      return
    end

    @coupon_issue_num_stat.errors.add("此操作导致总发行量小于0") if coupon.total_issue_number <=0
    @coupon_issue_num_stat.errors.add("此操作导致实际剩余量小于0") if coupon.existing_number <= 0
    @coupon_issue_num_stat.errors.add("此操作导致虚似剩余量小于0") if coupon.virtual_existing_number <= 0

    respond_to do |format|
      if @coupon_issue_num_stat.errors.any?
        format.html { render :action => "new" }
      else
        if coupon.save && @coupon_issue_num_stat.save
          flash[:notice] = '创建建成功'
          format.html { redirect_to(admin_coupon_issue_num_stats_path(:coupon_id => coupon.id)) }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

end
