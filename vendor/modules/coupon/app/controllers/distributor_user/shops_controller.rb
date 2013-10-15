# encoding: utf-8
require_dependency 'coupon'
class DistributorUser::ShopsController < Coupon::DistributorUserController
  before_filter :can_create, :only => [:index, :new, :create]

  def index
    @shops = Distributor::Shop.paginate(
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

  def show
    @shop = Distributor::Shop.find(params[:id])
    raise CanCan::AccessDenied if @shop.distributor_id != @current_distributor.id

    if @shop.market_shop_id
      @mshop = MarketShop.find(@shop.market_shop_id, :include => :market)
    else
      @mshop = nil
    end
    
    respond_to do |format|
      format.html { }
    end
  end

  def new
    raise CanCan::AccessDenied unless @can_create
    @shop = Distributor::Shop.new
    @shop.city_id = City.first.id if @shop.city_id.to_i == 0
    @business_zone_options = [['不在商圈内', '']]
    @market_shop_options = [['请先选择地区与商圈', '']]
    @market_list_options = [['请先选择地区与商圈', '']]


    respond_to do |format|
      format.html { }
    end
  end

  def create
    raise CanCan::AccessDenied unless @can_create
    @shop = Distributor::Shop.new(params[:distributor_shop].update(:distributor_id => @current_distributor.id))

    respond_to do |format|
      if @shop.save
        format.html { redirect_to distributor_user_shops_path, :notice => "#{Distributor::Shop.human_name}创建成功." }
      else
        format.html { render 'new' }
      end
    end
  end

  def edit
    @shop = Distributor::Shop.find(params[:id])
    raise CanCan::AccessDenied if @shop.distributor_id != @current_distributor.id
    @shop.city_id = City.first.id if @shop.city_id.to_i == 0
    @business_zone_options = [['不在商圈内', '']]
    @market_shop_options = [['请先选择地区与商圈', '']]
    @market_list_options = [['请先选择地区与商圈', '']]

    respond_to do |format|
      format.html { }
    end
  end

  def update
    @shop = Distributor::Shop.find(params[:id])
    raise CanCan::AccessDenied if @shop.distributor_id != @current_distributor.id
    @shop.city_id = City.first.id if @shop.city_id.to_i == 0
    @business_zone_options = [['不在商圈内', '']]
    @market_shop_options = [['请先选择地区与商圈', '']]
    @market_list_options = [['请先选择地区与商圈', '']]
    
    respond_to do |format|
      if @shop.update_attributes(params[:distributor_shop])
        format.html { redirect_to distributor_user_shops_path, :notice => "#{Distributor::Shop.human_name}修改成功." }
      else
        format.html { render 'edit' }
      end

    end
  end

  private
  def can_create
    setting = AppResourceSetting.first(:conditions => ["resource_type = 'HejiaUserBbs' and resource_id = ? and `key`='account_type' and channel = 'distributor_user_config'", @current_ability_user.USERBBSID])
    if setting
      if setting.value == "2"
        @can_create = true
      else
        @can_create = false
      end
    else
      @can_create = false
    end
  end
  
end