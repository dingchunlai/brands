require_dependency 'coupon/admin_controller'
class Admin::OfferCouponsController < Coupon::AdminController
  load_and_authorize_resource
  
  def index
    @offer_coupons = OfferCoupon.with_merchant(params[:merchant]).with_status(params[:status]).paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20, :include => [ :city, :district ])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @offer_coupon = OfferCoupon.find(params[:id], :include => [ :city, :district ])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @offer_coupon = OfferCoupon.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @offer_coupon = OfferCoupon.find(params[:id])
    @districts = District.by_city(@offer_coupon.city_id)
  end

  def create
    @offer_coupon = OfferCoupon.new(params[:offer_coupon])

    respond_to do |format|
      if @offer_coupon.save
        flash[:notice] = 'OfferCoupon was successfully created.'
        format.html { redirect_to(admin_offer_coupons_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @offer_coupon = OfferCoupon.find(params[:id])

    respond_to do |format|
      if @offer_coupon.update_attributes(params[:offer_coupon])
        flash[:notice] = 'OfferCoupon was successfully updated.'
        format.html { redirect_to(admin_offer_coupon_path(@offer_coupon)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @offer_coupon = OfferCoupon.find(params[:id])
    @offer_coupon.update_attributes(:deleted => true)
    respond_to do |format|
      format.html { redirect_to(admin_offer_coupons_path) }
    end
  end

end
