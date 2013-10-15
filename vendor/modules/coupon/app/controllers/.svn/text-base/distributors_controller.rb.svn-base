# encoding: utf-8

# Front_Page distributors_controller 
class DistributorsController < CouponApplicationControllerController

  after_filter :update_pv

  # Distributor of coupons 
  def index # Type of HuiYuan
    @distributor = Distributor::HuiYuan.find_by_id params[:id]
    unless @distributor.blank?
=begin
      Object.subclasses_of(Distributor).collect { |obj| [obj.human_name, obj.to_s] }.each do |text, key|
      end
=end
    else
      redirect_to coupon_index_path 
    end
  end

  # Distributor  
  def show
    # Type of HuiYuan
    @distributor = Distributor::HuiYuan.find_by_id params[:id]

    unless @distributor.blank?
    else
      redirect_to coupon_index_path 
    end
  end

  # save distributor impression
  def save_impression
    @distributor = Distributor.find_by_id params[:id]
    @distributor.add_impression(params[:title], 1, true, request.session_options[:id])

    unless @distributor.impression_errors.full_messages.empty?
      render :json => @distributor.impression_errors.full_messages, :status => 500
    else
      render :json => @distributor.latest_impression
    end
  end

  # update Distributor PV
  private
    def update_pv
      @distributor.increase_pv_count
    end
end
