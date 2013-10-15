require_dependency 'coupon/admin_controller'
class Admin::MarketsController < Coupon::AdminController
  load_and_authorize_resource
  
  def index
    @markets = Market.search(params[:name]).paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @market = Market.find(params[:id])
    @market_shops = @market.market_shops

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @market = Market.new
    @market.market_shops.build(:when_market_create => "1")

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @market = Market.find(params[:id])
    @market_shops = @market.market_shops.with_locations
  end

  def create
    @market = Market.new(params[:market])

    respond_to do |format|
      if @market.save
        flash[:notice] = 'Market was successfully created.'
        format.html { redirect_to(admin_markets_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @market = Market.find(params[:id])

    respond_to do |format|
      if @market.update_attributes(params[:market])
        flash[:notice] = '卖场成功创建!'
        format.html { redirect_to(admin_market_path(@market)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @market = Market.find(params[:id])
    if @market.market_shops_count > 0
      redirect_to(admin_markets_path, :alert => '无法完成此操作, 请先行删除下属卖场分店')
      return
    end
    @market.mark_deleted
    respond_to do |format|
      format.html { redirect_to(admin_markets_path) }
    end
  end

end
