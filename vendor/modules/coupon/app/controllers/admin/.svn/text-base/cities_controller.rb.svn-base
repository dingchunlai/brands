require_dependency 'coupon/admin_controller'

class Admin::CitiesController < Coupon::AdminController
  load_and_authorize_resource

  def index
    #@cities = City.paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)
    options = {:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20, :include => :province }
    if params[:province_id]
      province = Province.find(params[:province_id])
      @cities = province.cities.paginate(options)
    else
      @cities = City.paginate(options)
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @city = City.find(params[:id])
  end

  def create
    @city = City.new(params[:city])
    pinyin = ChineseDictionary.pinyin_for @city.name, :join_with => '_'
    @city.pinyin = pinyin.gsub "_", ""
    @city.code_name = pinyin.classify.gsub(/([a-z])/, "").downcase

    respond_to do |format|
      if @city.save
        format.html { redirect_to(new_admin_city_path, :notice => "添加成功,请继续添加!") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(admin_city_path(@city)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @city = City.find(params[:id])
    if @city.districts_count > 0
      redirect_to(admin_cities_path, :alert => '无法完成此操作, 请先行删除下属地区')
      return
    end
    @city.mark_deleted
    respond_to do |format|
      format.html { redirect_to(admin_cities_path) }
    end
  end

end
