require_dependency 'coupon/admin_controller'

class Admin::DistrictsController < Coupon::AdminController
  load_and_authorize_resource
  
  def index
    options = {:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20, :include => :city }
    if params[:city_id]
      city = City.find(params[:city_id])
      @districts = city.districts.paginate(options)
    else
      @districts = District.paginate(options)
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @district = District.find(params[:id], :include => :city)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @district = District.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @district = District.find(params[:id])
  end

  def create
    @district = District.new(params[:district])
    @district.pinyin = ChineseDictionary.pinyin_for @district.name
    
    respond_to do |format|
      if @district.save
        format.html { redirect_to(new_admin_district_path(:city_id => @district.city_id), :notice => "添加成功,请继续添加!") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @district = District.find(params[:id])
    
    respond_to do |format|
      if @district.update_attributes(params[:district])
        format.html { redirect_to(admin_district_path(@district)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @district = District.find(params[:id])
    if @district.business_zones_count > 0
      redirect_to(admin_districts_path(:city_id => @district.city_id), :alert => '无法完成此操作, 请先行删除下属商圈')
      return
    end
    @district.mark_deleted

    respond_to do |format|
      format.html { redirect_to(admin_districts_path(:city_id => @district.city_id)) }
    end
  end

end
