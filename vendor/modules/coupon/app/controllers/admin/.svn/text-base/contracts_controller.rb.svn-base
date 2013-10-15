# encoding : utf-8
require_dependency 'coupon/admin_controller'
class Admin::ContractsController < Coupon::AdminController

  #load_and_authorize_resource :class => Distributor::Contract

  before_filter :load_distributor, :only => [:index, :new, :destroy]

  def index
    contracts = @distributor.contracts
    contracts = unless params[:title].blank?
      @title = params[:title]
      contracts.with_title params[:title]
    else
      contracts
    end
     
    @contracts = contracts && contracts.paginate(:page => params[:page], :per_page => 20) || []
    # authorize! :read, Distributor::Contract 
    if can? :read, Distributor::Contract 

    elsif can? :read_owned_contracts, Distributor::Contract 
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@distributor.id)
        # 包含
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contracts }
    end
  end

  def show
    @contract = Distributor::Contract.find(params[:id])
    # authorize! :read, @contract 
    if can? :read, Distributor::Contract 
    elsif can? :read_owned_contracts, Distributor::Contract 
      if current_ability_user.owned_contracts.include?(@contract.id)
        # 包含
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contract }
    end
  end

  def new
    @contract = Distributor::Contract.new
    @users = RadminUser.with_sales
    authorize! :create, @contract 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contract }
    end
  end

  def edit
    @users = RadminUser.with_sales
    @contract = Distributor::Contract.find_by_id(params[:id])

    # authorize! :update, @contract 
    if can? :update, Distributor::Contract 
    elsif can? :edit_owned_contract, Distributor::Contract 
      if current_ability_user.owned_contracts.include?(@contract.id)
        # 包含
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end

  end

  def create
    @distributor = Distributor.find_by_id params[:distributor_contract][:distributor_id]
    @contract = Distributor::Contract.new(params[:distributor_contract])
    authorize! :create, @contract 

    respond_to do |format|
      if @contract.save
        flash[:notice] = '经销商创建成功 .'
        format.html { redirect_to(admin_distributor_contracts_path(@contract.distributor_id)) }
        format.xml  { render :xml => @contract, :status => :created, :location => @contract }
      else
        @users = RadminUser.with_sales
        format.html { render :action => :new }
        format.xml  { render :xml => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @contract = Distributor::Contract.find_by_id(params[:id])
    # authorize! :update, @contract 

    if can? :update, Distributor::Contract 
    elsif can? :edit_owned_contract, Distributor::Contract 
      if current_ability_user.owned_contracts.include?(@contract.id)
        # 包含
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end


    respond_to do |format|
      if @contract.update_attributes(params[:distributor_contract])
        flash[:notice] = '经销商修改成功 .'
        format.html { redirect_to(admin_distributor_contracts_path(@contract.distributor_id)) }
        format.xml  { head :ok }
      else
        @users = RadminUser.with_sales
        format.html { render :action => :edit }
        format.xml  { render :xml => @contract.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @contract = Distributor::Contract.find(params[:id])
    #authorize! :update, @contract 
    raise CanCan::AccessDenied

    @contract.mark_deleted
    respond_to do |format|
      format.html { redirect_to(admin_distributor_contracts_path(@distributor)) }
      format.xml  { head :ok }
    end
  end

  # 必须是某个经销商下面的合同信息
  def load_distributor
    @distributor = Distributor.find_by_id params[:distributor_id]
    unless @distributor
      redirect_to admin_distributors_path
    end
  end
  private :load_distributor


end
