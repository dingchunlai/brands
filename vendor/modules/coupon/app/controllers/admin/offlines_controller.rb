class Admin::OfflinesController < Coupon::AdminController

  load_and_authorize_resource :class => OfflineAddress

  # ==    关于线下地址的设置======
  def index
    addresses =  OfflineAddress
    addresses, @city = addresses.of_city(params[:city_id]), params[:city_id].to_i if params[:city_id].to_i != 0
    addresses, @area = addresses.of_district(params[:area_id]), params[:area_id].to_i if params[:area_id].to_i != 0
    authorize! :read, OfflineAddress

    @offline_addresses = addresses.paginate :include => [:city, :district], :page => (params[:page] && params[:page].to_i || 1), :per_page => 20
  end
  
  def new
    @offline_address = OfflineAddress.new
    authorize! :create, @offline_address
  end

  def create
    @offline_address = OfflineAddress.new(params[:offline_address])
    authorize! :create, @offline_address
    if @offline_address.save
      redirect_to :action => :new
    else
      render :action => :new
    end
  end

  def edit
    @offline_address = OfflineAddress.find_by_id params[:id]
    authorize! :update, @offline_address
    @area = District.by_city(@offline_address.city_id)
  end

  def update
    @offline_address= OfflineAddress.find_by_id params[:id]
    authorize! :update, @offline_address
    if @offline_address.update_attributes params[:offline_address]
      redirect_to admin_offlines_path
    else
      render :action => :edit
    end
  end

  def destroy
    address = OfflineAddress.find_by_id params[:id]
    authorize! :update, address
    address.mark_deleted
    redirect_to request.env["HTTP_REFERER"]
  end
 
  # ===  线下信息设置结束 === 

end
