require_dependency 'coupon/admin_controller'
class Admin::DistributorsController < ::Coupon::AdminController

  # load_and_authorize_resource

  # GET /distributors
  def index

    if can? :read, Distributor 
      @distributors = Distributor
    elsif can? :read_owned_distributors, Distributor 
      @distributors = Distributor.with_contracts(current_ability_user.owned_contracts) 
    else
      raise CanCan::AccessDenied
    end

    @distributors = @distributors.with_title(params[:title]).with_code(params[:code]).with_sign_status(params[:contract_status]).paginate(
            :page => ((params[:page].to_i==0)? 1 : params[:page].to_i),
            :per_page => 20
    )
    distributor_ids = @distributors.map(&:id)
    profiles = DistributorAccountProfile.find(:all, :conditions => ["distributor_id in (?)", distributor_ids], :include => :distributor_account)
    @account_hash = profiles.inject({}) { |hash, profile| hash[profile.distributor_id]=profile.distributor_account; hash }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @distributors }
    end
  end

  # GET /distributors/1
  def show
    @distributor = Distributor.find(params[:id], :include => [:coupons, :shops, :contracts])

    if can? :read, @distributor 
    elsif can? :read_owned_distributors, @distributor
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@distributor.id)
        # 包含
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end

    @structs = Distributor::Contract.statistic_by_distributor(params[:id])
    @coupon_total_count = Coupon.count
    @coupon_valid_count = Coupon.valid.count
    @shops = @distributor.shops.first(5)
    @coupons = @distributor.coupons.first(5)
    @contracts = @distributor.contracts.first(5)
  end

  # GET /distributors/new
  def new
    @distributor = Distributor.new
    @distributor_account = DistributorAccount.new
    #authorize! :create, @distributor 
    if can? :create, @distributor
    else
      raise CanCan::AccessDenied
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @distributor }
    end
  end

  # GET /coupon_agencies/1/edit
  def edit
    @distributor = Distributor.find(params[:id])
    #authorize! :update, @distributor 

    if can? :read, @distributor 
    elsif can? :edit_owned_distributor, @distributor
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@distributor.id)
        # 包含
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end
  end

  # POST /coupon_agencies
  # POST /coupon_agencies.xml
  def create
    @distributor = Distributor.new(params[:distributor])
    @distributor_account = DistributorAccount.new(params[:distributor_account])
    pwd = generate_password
    @distributor_account.USERSPASSWORD = pwd
    @distributor_account.PASSWORD_CONFIRMATION = pwd
    authorize! :create, @distributor 

    respond_to do |format|
      if @distributor_account.save && @distributor.save 
        DistributorAccountProfile.create!(:distributor => @distributor, :distributor_account => @distributor_account)
        #@distributor_account.deliver_welcome! if RAILS_ENV == 'production'
        flash[:notice] = '经销商创建成功'
        format.html { redirect_to(admin_distributors_path) }
        format.xml  { render :xml => @distributor, :status => :created, :location => @distributor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @distributor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coupon_agencies/1
  # PUT /coupon_agencies/1.xml
  def update
    @distributor = Distributor.find(params[:id])
    # authorize! :update, @distributor 

    if can? :read, @distributor 
    elsif can? :edit_owned_distributor, @distributor
      if Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).include?(@distributor.id)
        # 包含
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end

    respond_to do |format|
      if @distributor.update_attributes(params[:distributor])
        save_pictures(@distributor.pictures, params[:pictures], @distributor)
        flash[:notice] = 'Distributor was successfully updated.'
        # format.html { render :action => "edit" }
        format.html { redirect_to(edit_admin_distributor_path(@distributor)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @distributor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor/1
  def destroy
    @distributor = Distributor.find(params[:id])
    # @distributor.destroy
    # authorize! :update, @distributor 
    raise CanCan::AccessDenied

    respond_to do |format|
      success = false
      begin
        @distributor.mark_deleted
        success = true
      rescue
        success = false
      end
      if success
        format.html { redirect_to(admin_distributors_path, :notice => '经销商成功删除') }
      else
        format.html { redirect_to(admin_distributors_path, :notice => '经销商删除失败') } 
      end

    end
  end

  def decofirm
    authorize! :decofirm, :distributors
    @distributor = Distributor.find(params[:id])
    @decofirm = @distributor.deco_firm
    @associated = @distributor.distributor_decofirm || DistributorDecofirm.create(:distributor_id => @distributor.id, :deco_firm_id => @decofirm.nil? ? '' : @decofirm.id )
    respond_to do |format|
      format.html {}      
    end
  end

  def associate_decofirm
    authorize! :associate_decofirm, :distributors
    @distributor = Distributor.find(params[:id])
    decofirm = @distributor.distributor_decofirm# || DistributorDecofirm.create(params[:distributor_decofirm])
    respond_to do |format|
      if decofirm.update_attributes(params[:distributor_decofirm])
        format.html { redirect_to(decofirm_admin_distributor_path(@distributor), :notice => '经销商-装修公司 成功关联!') }
      else
        format.html { redirect_to(decofirm_admin_distributor_path(@distributor), :alert => '经销商-装修公司 关联失败!') }
      end
    end
  end

  def shops_json
    distributor_id = params[:id].to_i
    return render :json => [] if distributor_id == 0
    shops = Distributor::Shop.by_distributor(distributor_id).map{|r| [r.name, r.id]}
    render :json => shops.to_json
  end

  # 重置密码 111111
  def reset_password
    authorize! :manage_distributor_account_profile, :distributors
    @distributor = Distributor.find(params[:id])
    profile = DistributorAccountProfile.find(:first, :conditions => ["distributor_id = ?", @distributor.id])
    @account = profile.distributor_account

    respond_to do |format|
      if @account.update_attributes(:USERSPASSWORD => '111111')
        format.html { redirect_to :back, :notice => '重置密码成功!' }
      else
        format.html { redirect_to :back, :notice => '重置密码失败，请与管理员联系!' }
      end
    end
  end

  # 经销商用户行业品牌
  def industry_brand_setting
    authorize! :manage_distributor_account_profile, :distributors
    @distributor = Distributor.find(params[:id])
    profile = DistributorAccountProfile.find(:first, :conditions => ["distributor_id = ?", @distributor.id])
    @account = profile.distributor_account
    
    @industry_brands = @account.industry_brands.group_by(&:industry_id)
    respond_to do |format|
      format.html {}
    end
  end

  # 经销商用户行业品牌设定
  def save_industry_brand_setting
    authorize! :manage_distributor_account_profile, :distributors
    @distributor = Distributor.find(params[:id])
    profile = DistributorAccountProfile.find(:first, :conditions => ["distributor_id = ?", @distributor.id])
    @account = profile.distributor_account
    @industry_brands = @account.industry_brands.group_by(&:industry_id)
    
    if params[:distributor_account_profile] && params[:distributor_account_profile][:brands]
      DistributorAccountIndustryBrand.transaction do
         DistributorAccountIndustryBrand.delete_all(["distributor_account_id = ?", @account.id])
         params[:distributor_account_profile][:brands].each do |item|
           tag, brand = item.split("-")
           DistributorAccountIndustryBrand.create(:industry_id => tag, :brand_id => brand, :distributor_account_id => @account.id)
         end
      end
      respond_to do |format|
        format.html { redirect_to :back }
      end
    else
      respond_to do |format|
        format.html {
          
          render 'industry_brand_setting', :notice => '请选择品牌'
        }
      end
    end
  end

  def impressions
    authorize! :impressions, :distributors
 
    @distributor = Distributor.find_by_id params[:id]
    if request.post?
      unless @distributor.blank? 
        attributes = params[:attributes]
        values = params[:values]
        attributes.each do |key, name|
          unless name.blank?
            @distributor.add_impression(name, values[key].to_i) unless name.blank?
          end
        end
      end
    end
  end

  # delete Impression
  def destroy_impression
    authorize! :destroy_impression, :distributors
    @distributor = Distributor.find_by_id params[:id]
    @distributor.destroy_impression(params[:title]) 
    redirect_to :action => :impressions, :id => @distributor.id
  end

  # 经销商用户配置
  def show_settings
    authorize! :manage_distributor_account_profile, :distributors
    @distributor = Distributor.find(params[:id])
    profile = DistributorAccountProfile.find(:first, :conditions => ["distributor_id = ?", @distributor.id])
    @account = profile.distributor_account
    @settings = @account.settings.find(:all, :conditions => {:channel => 'distributor_user_config'})

    if @settings.empty?
      @account.settings.build(:name => "可录入抵用券数量", :key => 'max_coupons_count', :channel => 'distributor_user_config', :summary => "可录入抵用券数量")
      @account.settings.build(:name => "帐号类型", :key => 'account_type', :channel => 'distributor_user_config', :summary => "帐号类型:1. 录入抵用券 2. 抵用券+门店")
    end
    respond_to do |format|
      format.html { }
    end
  end

  # 经销商用户配置保存
  def save_settings
    authorize! :manage_distributor_account_profile, :distributors
    @distributor = Distributor.find(params[:id])
    profile = DistributorAccountProfile.find(:first, :conditions => ["distributor_id = ?", @distributor.id])
    @account = profile.distributor_account
    if @account.update_attributes(params[:distributor_account])
      redirect_to show_settings_admin_distributor_path(@distributor)
    else
      render 'show_settings'
    end
  end

  private
    def generate_password
      limit = 6
      rand(36**limit).to_s(36)
    end

    def save_pictures(old_pictures, pictures, object)
      return if pictures.blank? && old_pictures.blank?

      old_pics, pics = old_pictures.map(&:id), []
      pictures && pictures.each do |picture|
        if pic = Picture.find_by_id(picture[:id])
          pics << picture[:id]
          pic.update_attributes(picture)
        else
          pic = Picture.new(picture)
          pic.item = object  
          pic.save
        end
      end
      Picture.destroy [old_pics - pics] unless [old_pics - pics].blank?
    end

end
