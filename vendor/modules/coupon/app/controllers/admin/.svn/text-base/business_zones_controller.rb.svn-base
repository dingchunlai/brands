require_dependency 'coupon/admin_controller'
class Admin::BusinessZonesController < Coupon::AdminController
  load_and_authorize_resource

  def index
    options = { :page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20, :include => [:city, :district] }
    if params[:district_id]
      @district = District.find(params[:district_id])
      @business_zones = @district.business_zones.paginate(options)
    else
      @business_zones = BusinessZone.paginate(options)       
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @business_zone = BusinessZone.find(params[:id], :include => [:city, :district])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @business_zone = BusinessZone.new

    @districts = []
    if params[:district_id]
      district = District.find(params[:district_id])
      @business_zone.city_id = district.city_id
      @business_zone.district_id = district.id
      @districts =City.find(district.city_id).districts
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @business_zone = BusinessZone.find(params[:id])
  end

  def create
    @business_zone = BusinessZone.new(params[:business_zone])
    @business_zone.pinyin = ChineseDictionary.pinyin_for @business_zone.name
    
    respond_to do |format|
      if @business_zone.save
        format.html { redirect_to(new_admin_business_zone_path(:district_id => @business_zone.district_id), :notice => "添加成功,请继续添加!") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @business_zone = BusinessZone.find(params[:id])

    respond_to do |format|
      if @business_zone.update_attributes(params[:business_zone])
        format.html { redirect_to(admin_business_zone_path(@business_zone)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @business_zone = BusinessZone.find(params[:id])
    @business_zone.mark_deleted
    respond_to do |format|
      format.html { redirect_to(admin_business_zones_path(:district_id => @business_zone.district_id )) }
    end
  end

end
