require_dependency 'coupon/admin_controller'
class Admin::ShopsController < Coupon::AdminController

  #load_and_authorize_resource :class => Distributor::Shop

  def index
    @distributor_id = params[:distributor_id].to_i
    return render_404 if @distributor_id == 0

    if can? :read, Distributor::Shop
      # 权限正常
    elsif can? :read_owned_shops, Distributor::Shop 
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@distributor_id)
        # 包含 正常
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end
 
    @search = Distributor::Shop.new_search(params[:search], @distributor_id)
    @shops = @search.searh.paginate :per_page => 20, :page => page
  end

  def new
    @distributor_id = params[:distributor_id].to_i
    @shop = Distributor::Shop.new

    authorize! :create, @shop
    @shop.city_id = City.first.id if @shop.city_id.to_i == 0
    @business_zone_options = [['不在商圈内', '']]
    @market_shop_options = [['请先选择地区与商圈', '']]
    @market_list_options = [['请先选择地区与商圈', '']]
    respond_to do |format|
      format.html { render :action => :edit}
      format.xml  { render :xml => @shop }
    end
  end

  def create
    @distributor_id = params[:distributor_id].to_i
    @distributor = Distributor.find(@distributor_id)
    @shop = @distributor.shops.new(params[:shop])

    authorize! :create, @shop
    @market_list_options = [['请先选择地区', '']]
    respond_to do |format|
      if @shop.save
        flash[:notice] = '店面添加成功！'
        format.html { redirect_to(admin_distributor_shops_path(@distributor_id)) }
        format.xml  { render :xml => @shop, :status => :created, :location => @shop }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @distributor_id = params[:distributor_id].to_i
    @shop = Distributor::Shop.find_by_id params[:id]

    # 验证门店为空
    if @shop.blank?
      redirect_to admin_distributor_shops_path(@distributor_id)
      return
    end

    if can? :update, Distributor::Shop
      # 权限正常
    elsif can? :edit_owned_shop, Distributor::Shop
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@distributor_id)
        # 包含 正常
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end
 
    @shop.city_id = City.first.id if @shop.city_id.to_i == 0
    @business_zone_options = BusinessZone.by_district(@shop.district_id).map{|b| [b.name,b.id]}.unshift(['不在商圈内',''])
    shops = MarketShop.by_district(@shop.district_id.to_i)
    shops = shops.by_business_zone(@shop.business_zone_id.to_i)
    @market_shop_options = shops.length > 0 ? shops.map{|d| [d.market_name + d.name, d.id]}.unshift(['请选择','']) : [['请先选择地区与商圈', '']]
    market_shop_ids = @market_shop_options.map{|s| s[1]}
    markets = market_shop_ids.length > 0 ? Market.all(:select => 'id, name', :conditions => ['id in (?)', market_shop_ids]) : []
    @market_list_options = markets.length > 0 ? markets.map{|m| [m.name, m.id]}.unshift(['请选择','']) : [['请先选择地区与商圈', '']]
  end

  def update
    @shop = Distributor::Shop.find(params[:id])

    if can? :update, Distributor::Shop
      # 权限正常
    elsif can? :edit_owned_shop, Distributor::Shop 
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@shop.distributor_id)
        # 包含 正常
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end
 
    respond_to do |format|
      if @shop.update_attributes(params[:shop])
        flash[:notice] = '店面信息修改成功！'
        format.html { redirect_to(admin_distributor_shops_path(@shop.distributor_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @distributor_id = params[:distributor_id].to_i
    @shop = Distributor::Shop.find(params[:id])
    if can? :read, Distributor::Shop
      # 权限正常
    elsif can? :read_owned_shops, Distributor::Shop
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@distributor_id)
        # 包含 正常
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end
  end

  def destroy
    @distributor_id = params[:distributor_id].to_i
    @shop = Distributor::Shop.find(params[:id])

    # 不准删除
    raise CanCan::AccessDenied

    @shop.mark_deleted
    redirect_to(admin_distributor_shops_path(@distributor_id)+"?page=#{params[:page]}")
  end

  def shops_by_title
    q = params[:q].to_s.strip
    if q.blank?
      shops = ""
    else
      shops = Distributor.record_by_id(params[:distributor_id]).shops.like_name(q).map{ |s| s.name }.join("\n")
    end
    render :text => shops
  end

end
