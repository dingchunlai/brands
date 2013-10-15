require_dependency 'coupon/admin_controller'

class Admin::CouponLeafletPointsController < Coupon::AdminController
  load_and_authorize_resource
  
  def index
    @coupon_leaflet_points = CouponLeafletPoint.paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @coupon_leaflet_point = CouponLeafletPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @coupon_leaflet_point = CouponLeafletPoint.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @coupon_leaflet_point = CouponLeafletPoint.find(params[:id])
  end

  def create
    @coupon_leaflet_point = CouponLeafletPoint.new(params[:coupon_leaflet_point])

    @coupon_leaflet_point.activity_begin_at = Time.zone.today - 1
    @coupon_leaflet_point.activity_end_at = Time.zone.today + 1.year

    respond_to do |format|
      if @coupon_leaflet_point.save
        format.html { redirect_to(admin_coupon_leaflet_point_path(@coupon_leaflet_point)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @coupon_leaflet_point = CouponLeafletPoint.find(params[:id])

    respond_to do |format|
      if @coupon_leaflet_point.update_attributes(params[:coupon_leaflet_point])
        format.html { redirect_to(admin_coupon_leaflet_point_path(@coupon_leaflet_point)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @coupon_leaflet_point = CouponLeafletPoint.find(params[:id])
    @coupon_leaflet_point.mark_deleted
    respond_to do |format|
      format.html { redirect_to(admin_coupon_leaflet_points_path) }
    end
  end

  def city_default
    if params[:city_id]
      @city = City.find(params[:city_id])
    else
      @city = City.find_by_name("上海") #默认上海      
    end
    if request.get?
      has_key = $redis.exists(CouponLeafletPoint.city_default_redis_key(@city.name))
      @point_info = {}
      if has_key
        props = $redis.get CouponLeafletPoint.city_default_redis_key(@city.name)
        unless props.to_s.empty?
          @point_info = YAML::load(props)
        end
      end
    else
      $redis.set CouponLeafletPoint.city_default_redis_key(@city.name), params[:city_default].ya2yaml(:syck_compatible => true)
      redirect_to city_default_admin_coupon_leaflet_points_path(:city_id => @city.id)
    end
  end

end
