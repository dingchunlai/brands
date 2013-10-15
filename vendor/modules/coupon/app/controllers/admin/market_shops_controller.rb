require_dependency 'coupon/admin_controller'
class Admin::MarketShopsController < Coupon::AdminController
  load_and_authorize_resource
  
  def index
    options = {:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20}
    @business_zone = nil    
    if params[:business_zone_id]
      options.update({ :conditions => ["business_zone_id = ?", params[:business_zone_id]] })
      @business_zone = BusinessZone.find(params[:business_zone_id])
    elsif params[:market_id]
      options.update({:conditions => ["market_id = ?", params[:market_id]] })
    end
    @market_shops = MarketShop.with_locations.paginate(options)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @market_shop = MarketShop.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @market_shop = MarketShop.new(:market_id => params[:market_id], :business_zone_id => params[:business_zone_id])
    #@business_zone = nil
    @cities = City.find(:all)
    @districts = []
    @business_zones = []
    if params[:business_zone_id]
      business_zone = BusinessZone.find(params[:business_zone_id])
      @market_shop.city_id = business_zone.city_id
      @market_shop.district_id = business_zone.district_id
      @districts = District.by_city(business_zone.city_id)
      @business_zones =  BusinessZone.by_district(business_zone.district_id)
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @market_shop = MarketShop.find(params[:id])
  end

  def create
    @market_shop = MarketShop.new(params[:market_shop])

    respond_to do |format|
      if @market_shop.save
        format.html { redirect_to(new_admin_market_shop_path(:market_id => @market_shop.market_id), :notice => "卖场门店添加成功！可继续添加！") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @market_shop = MarketShop.find(params[:id])

    respond_to do |format|
      if @market_shop.update_attributes(params[:market_shop])
        flash[:notice] = 'MarketShop was successfully updated.'
        format.html { redirect_to(admin_market_shop_path(@market_shop)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @market_shop = MarketShop.find(params[:id])
    @market_shop.update_attributes(:deleted => true)
    respond_to do |format|
      format.html { redirect_to(admin_market_shops_path) }
    end
  end

end
