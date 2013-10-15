# encoding: utf-8

# Front OfferCoupon

class OfferCouponsController < CouponApplicationControllerController

  def new
    @offer_coupon = OfferCoupon.new
  end

  def create
    @offer_coupon = OfferCoupon.new(params[:offer_coupon])
    respond_to do |format|
      if @offer_coupon.save
        format.html { redirect_to(:back) }
        format.js {}
      else
        format.html { render :action => "new" }
        format.js {}
      end
    end
  end

end
