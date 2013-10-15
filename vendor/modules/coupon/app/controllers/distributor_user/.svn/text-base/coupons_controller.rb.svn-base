# encoding: utf-8
require_dependency 'coupon'
class DistributorUser::CouponsController < Coupon::DistributorUserController
  before_filter :get_coupons_count, :only => [:index, :create, :new]
  before_filter :get_industry_brands, :only => [:new, :edit, :create]
  def index
    @coupons = ::Coupon.paginate(
        :all,
        :conditions => { :distributor_id => @current_distributor.id },
        :page => ((params[:page].to_i==0)? 1 : params[:page].to_i),
        :per_page => 20,
        :order => "id desc"
    )
    
    respond_to do |format|
      format.html { }
    end
  end

#  def show
#    @coupon = ::Coupon.find(params[:id])
#    raise CanCan::AccessDenied if @coupon.distributor_id != @current_distributor.id
#
#    respond_to do |format|
#      format.html { }
#    end
#
#  end

  def new
    if @coupons_count >= @max_coupons_count
      redirect_to distributor_user_coupons_path, :alert => "超过设置数量不可添加#{Coupon.human_name}"
      return
    end
    @coupon = ::Coupon.new(:distributor_id => @current_distributor.id)

    respond_to do |format|
      format.html { }
    end
  end

  def create
    if @coupons_count >= @max_coupons_count
      redirect_to distributor_user_coupons_path, :alert => "超过设置数量不可添加#{Coupon.human_name}"
      return
    end
    
    unless params[:production_category_ids]
      redirect_to :back, :alert => '操作提示: 品类必须选择!'
      return
    end

    @coupon = ::Coupon.new(params[:coupon].update(:virtual_existing_number => (5+rand(15)), :distributor_id => @current_distributor.id))
    production_categories = ProductionCategory.all(:conditions => ['id in (?)', params[:production_category_ids]])
    @coupon.production_categories = production_categories
    @coupon.status = 0
    respond_to do |format|
      if @coupon.save
        format.html { redirect_to distributor_user_coupons_path, :notice => "#{Coupon.human_name}添加成功，当前状态：待审核。" }
      else
        format.html { render 'new' }
      end
    end
  end

  def edit
    @coupon = ::Coupon.find(params[:id])
    raise CanCan::AccessDenied if @coupon.distributor_id != @current_distributor.id
    
    respond_to do |format|
      format.html { }
    end
  end

  def update
    unless params[:production_category_ids]
      redirect_to :back, :alert => '操作提示: 品类必须选择!'
      return
    end

    @coupon = ::Coupon.find(params[:id])
    raise CanCan::AccessDenied if @coupon.distributor_id != @current_distributor.id

    coupon = params[:coupon].merge( { :status => 0, :distributor_id => @current_distributor.id } )
    production_categories = ProductionCategory.all(:conditions => ['id in (?)', params[:production_category_ids]])
    @coupon.production_categories = production_categories
    
    respond_to do |format|
      if @coupon.update_attributes(coupon)
        format.html { redirect_to distributor_user_coupons_path, :notice => "#{Coupon.human_name}编辑成功，当前状态：待审核。" }
      else
        format.html { render 'edit' }
      end
    end
  end

  private
  # 获取抵用券数量
  def get_coupons_count
    @coupons_count = ::Coupon.count(:conditions => ["distributor_id = ?", @current_distributor.id])
    
    setting = AppResourceSetting.first(:conditions => ["resource_type = 'HejiaUserBbs' and resource_id = ? and `key`='max_coupons_count' and channel = 'distributor_user_config'", @current_ability_user.USERBBSID])
    if setting
      @max_coupons_count = setting.value.to_i
    else
      @max_coupons_count = 99999
    end
  end

  # 获取自定义行业品牌
  def get_industry_brands
    industry_brands = DistributorAccountIndustryBrand.find(
        :all,
        :conditions => { :distributor_account_id => @current_ability_user.USERBBSID },
        :select => "brand_id, industry_id, id",
        :include => :industry,
        :include => :brand
    )

    @industries = industry_brands.collect { |ib| [ib.industry_id, ib.industry.TAGNAME] }.uniq
    @brands = industry_brands.inject({}) { |hash, ibs| hash[ibs.industry_id] ||= []; hash[ibs.industry_id] << [ibs.brand_id, ibs.brand.name_zh]; hash }

  end

end