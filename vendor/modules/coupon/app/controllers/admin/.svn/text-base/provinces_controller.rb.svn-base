require_dependency 'coupon/admin_controller'

class Admin::ProvincesController < Coupon::AdminController
  load_and_authorize_resource

  def index
    @provinces = Province.paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @province = Province.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @province = Province.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @province = Province.find(params[:id])
  end

  def create
    @province = Province.new(params[:province])
    pinyin = ChineseDictionary.pinyin_for(@province.name, :join_with => '_')
    @province.pinyin = pinyin.gsub "_", ""
    @province.code_name = pinyin.classify.gsub(/([a-z])/, "").downcase

    respond_to do |format|
      if @province.save
        flash[:notice] = 'Province was successfully created.'
        format.html { redirect_to(admin_provinces_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @province = Province.find(params[:id])

    respond_to do |format|
      if @province.update_attributes(params[:province])
        flash[:notice] = '省份创建成功!'
        format.html { redirect_to(admin_province_path(@province)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @province = Province.find(params[:id])
    if @province.cities_count > 0
      redirect_to(admin_provinces_path, :alert => '无法完成此操作, 请先行删除下属城市')
      return
    end
    @province.mark_deleted
    respond_to do |format|
      format.html { redirect_to(admin_provinces_path) }
    end
  end

end
