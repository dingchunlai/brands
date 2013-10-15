require_dependency 'coupon/admin_controller'

class Admin::SalesProfilesController < Coupon::AdminController

  load_and_authorize_resource

  def index
    @sales_users = RadminUser.with_sales.paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)
    authorize! :read, SalesProfile 

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def assign_contracts
    raise CanCan::AccessDenied unless can?(:assign_contracts, :coupon_sales)

    @sales_users = RadminUser.coupon_sales

    @contracts = []
    if params[:sales_id]
      @contracts = Distributor::Contract.with_user(params[:sales_id]).include_association(:distributor).paginate(:page => (params[:page].to_i == 0) ? 1 : params[:page].to_i, :per_page => 21)
    end

    respond_to do |format|
      format.html
    end
  end

  def save_assign_contracts
    raise CanCan::AccessDenied unless can?(:assign_contracts, :coupon_sales)
    
    from_sales_id = params[:from_sales_id]
    to_sales_id = params[:to_sales_id]
    Distributor::Contract.update_all({:radmin_user_id => to_sales_id.to_i, :updated_at => Time.zone.now }, ["id in (?)", params[:contracts]])
    respond_to do |format|
      format.html { redirect_to assign_contracts_admin_sales_profiles_path(:sales_id => from_sales_id), :notice => '成功分配!' }
    end
  end

  def show
    @sales_profile = SalesProfile.find(params[:id])
    authorize! :read, @sales_profile 

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @user = RadminUser.find_by_id params[:user_id]
    authorize! :create, @sales_profile 

    unless @user.blank?
      @sales_profile = SalesProfile.new

      respond_to do |format|
        format.html # new.html.erb
      end
    else
      redirect_to admin_sales_profiles_path
    end
  end

  def edit
    @sales_profile = SalesProfile.find(params[:id])
    authorize! :update, @sales_profile 
  end

  def create
    @sales_profile = SalesProfile.new(params[:sales_profile])
    authorize! :create, @sales_profile 

    respond_to do |format|
      if @sales_profile.save
        flash[:notice] = 'SalesProfile was successfully created.'
        format.html { redirect_to(admin_sales_profiles_path) }
      else
        @user = RadminUser.find_by_id params[:sales_profile][:user_id]
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @sales_profile = SalesProfile.find(params[:id])
    authorize! :update, @sales_profile 

    respond_to do |format|
      if @sales_profile.update_attributes(params[:sales_profile])
        flash[:notice] = 'SalesProfile was successfully updated.'
        format.html { redirect_to(admin_sales_profile_path(@sales_profile)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @sales_profile = SalesProfile.find(params[:id])
    authorize! :update, @sales_profile 
    @sales_profile.update_attributes(:deleted => true)
    respond_to do |format|
      format.html { redirect_to(admin_sales_profiles_path) }
    end
  end

end
