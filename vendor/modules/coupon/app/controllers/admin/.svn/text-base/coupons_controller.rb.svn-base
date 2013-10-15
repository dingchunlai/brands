require_dependency 'coupon/admin_controller'
class Admin::CouponsController < Coupon::AdminController
  
  #  load_and_authorize_resource

  before_filter :load_coupons, :only => [:sort]
  before_filter :find_coupon,  :only => [:move, :insert_at]

  def index
    @distributor, @title, @code = params[:distributor], params[:title], params[:code]
    @distributor_id = params[:distributor_id].to_i
    @validity_num = params[:validity_num].to_i
    @validity_unit = params[:validity_unit] || 'years'
    @tag_id = params[:tag_id].to_i
    @brand_id = params[:brand_id].to_i
    @shop_id = params[:shop_id].to_i
    @city_id = params[:city_id].to_i
    @status = params[:status] && params[:status].to_i || -1
    @coupons = ::Coupon
    
    if @distributor_id > 0
      @distributor = Distributor.id_to_title(@distributor_id)
      @coupons = @coupons.by_distributor_ids([@distributor_id])
    else
      unless @distributor.blank?
        distributor_ids = Distributor.like_title(@distributor).map{ |d| d.id }
        @coupons = @coupons.by_distributor_ids(distributor_ids)
      end
    end

    if @validity_num > 0
      validity_time = eval("#{@validity_num}.#{@validity_unit}")
      @coupons = @coupons.by_validity_time(validity_time)
    end
    @coupons = @coupons.with_status(@status) if @status > -1
    @coupons = @coupons.by_tag_id(@tag_id) if @tag_id > 0
    @coupons = @coupons.by_brand_id(@brand_id) if @brand_id > 0
    @coupons = @coupons.by_shop(@shop_id) if @shop_id > 0
    @coupons = @coupons.with_title(@title) if @title
    @coupons = @coupons.like_code(@code) if @code
    @coupons = @coupons.by_city(@city_id) if @city_id > 0

    if can? :read, Coupon# do nothing prevent administrator manage all permission

    elsif can? :read_owned_coupons, :coupons
      @coupons = @coupons.with_contracts(current_ability_user.owned_contracts)
    else
      raise CanCan::AccessDenied
    end

    @coupons = @coupons.paginate :order => 'id desc', :per_page => 20, :page => page
  end

  def new
    authorize! :create, Coupon
    @coupon = ::Coupon.new
    session[:current_distributor_id] ||= 1
    @coupon.usage = Coupon.default_usage
    @coupon.distributor_id ||= session[:current_distributor_id]
    render :action => :edit
  end

  def create
    authorize! :create, Coupon
    unless params[:production_category_ids]
      redirect_to new_admin_coupon_path, :alert => '操作提示: 品类必须选择!'
      return
    end
    @coupon = ::Coupon.new(params[:coupon])
    production_categories = ProductionCategory.all(:conditions => ['id in (?)', params[:production_category_ids]])
    @coupon.production_categories = production_categories
    if @coupon.save
      @coupon.move_to_top if params[:is_priority] #排序优先内容，
      if @coupon.status == 0
        redirect_to(edit_admin_coupon_path(@coupon), :notice => '操作提示：抵用券已经成功添加！(校对信息或返回列表页)')
      else
        redirect_to(new_admin_coupon_path, :notice => '操作提示：抵用券已经成功添加！(请继续添加)')
      end
    else
      render :action => "edit"
    end
  end

  def edit
    if can? :update, Coupon
      @coupon = ::Coupon.find(params[:id])
    elsif can? :edit_owned_coupon, :coupons
      @coupon = ::Coupon.find(params[:id])
      unless current_ability_user.owned_contracts.include? @coupon.contract_id
        raise CanCan::AccessDenied
      end
    end
    session[:current_distributor_id] ||= 1
    @coupon.distributor_id ||= session[:current_distributor_id]
  end

  def update
    #authorize! :update, @coupon
    if can? :update, Coupon
      @coupon = ::Coupon.find(params[:id])
    elsif can? :edit_owned_coupon, :coupons
      @coupon = ::Coupon.find(params[:id])
      unless current_ability_user.owned_contracts.include? @coupon.contract_id
        raise CanCan::AccessDenied
      end
    end

    # 更新当月佣金
    if params[:update_current_month_commission] == "1"
      coupon_commissions = CouponCommission.with_current_month(@coupon.id)
      if coupon_commissions.size > 0
        @coupon.commission = coupon_commissions.first.commission
      else
        @coupon.commission = 0
      end
    end
    
    coupon = params[:coupon].merge({:status => 0})
    production_categories = ProductionCategory.all(:conditions => ['id in (?)', params[:production_category_ids]])
    @coupon.production_categories = production_categories
    # 获取发行量的新旧值
    if @coupon.update_attributes(coupon)
      session[:current_distributor_id] = @coupon.distributor_id
      js_str = "<script type='text/javascript'>\n"
      js_str << "if (confirm(\"更新委托确认单?\\n\\r点[确定] 进入委托确认单页\\n\\r点[取消]返回列表页\")) {\n"
      js_str << "location.href='#{entrust_admin_coupon_path(@coupon)}';\n"
      js_str << "} else {\n"
      js_str << "location.href='#{admin_coupons_path}';\n"
      js_str << "}\n"
      js_str << "</script>"
      render :text => js_str
      return
    else
      render :action => :edit
    end
    
  end

  def destroy
    @coupon = ::Coupon.find(params[:id])
    #authorize! :update, @coupon
    # 暂不提供删除功能
    raise CanCan::AccessDenied
    @coupon.mark_deleted
    redirect_to(admin_coupons_path+"?page=#{params[:page]}")
  end

  # 数据统计
  def data
    authorize! :data, Coupon
    @cities = City.find(:all).collect { |item| [item.name, item.id] }
    @industries = Industry.all_categories.collect { |item| [item.TAGNAME, item.TAGID] }
    @markets = Market.all.collect { |item| [item.name, item.id] }
    conditions = ["1=1"]
    unless params[:date_begin].blank?
      conditions[0] << " and coupons.activity_began_at >= ? "
      conditions << Time.zone.parse(params[:date_begin]).beginning_of_day
    end

    unless params[:date_end].blank?
      conditions[0] << " and coupons.activity_end_at <= ? "
      conditions << Time.zone.parse(params[:date_end]).end_of_day
    end

    unless params[:city_id].blank?
      conditions[0] << " and coupons.city_id = ? "
      conditions << params[:city_id]
    end

    unless params[:tag_id].blank?
      conditions[0] << " and coupons.tag_id = ? "
      conditions << params[:tag_id]
    end

    unless params[:market_id].blank?
      conditions[0] << " and markets.id = ? "
      conditions << params[:market_id]
    end

    unless params[:distributor_id].blank?
      conditions[0] << " and coupons.distributor_id = ? "
      conditions << params[:distributor_id]
    end

    unless params[:distributor_title].blank?
      conditions[0] << " and distributors.title like ? "
      conditions << "%#{params[:distributor_title]}%"
    end

    unless params[:shop_name].blank?
      conditions[0] << " and distributor_shops.name like ? "
      conditions << "%#{params[:shop_name]}%"
    end

    unless params[:coupon_id].blank?
      conditions[0] << " and coupons.id = ? "
      conditions << "#{params[:coupon_id]}"
    end

    unless params[:coupon_title].blank?
      conditions[0] << " and coupons.title like ? "
      conditions << "%#{params[:coupon_title]}%"
    end

    joins = "join distributor_shops on distributor_shops.id=coupons.shop_id "\
      "join distributors on distributors.id=coupons.distributor_id "\
      "join cities on cities.id=coupons.city_id "
    # 仅当用选择卖场时 关联查询
    unless params[:market_id].blank?
      joins << "right join market_shops on market_shops.id = distributor_shops.market_shop_id "\
        "join markets on markets.id = market_shops.market_id "
    end

    if can? :read, Coupon# do nothing prevent administrator manage all permission

    elsif can? :read_owned_coupons, :coupons
      conditions[0] << " and coupons.contract_id in (?) "
      conditions << current_ability_user.owned_contracts
    else
      raise CanCan::AccessDenied
    end

    # 2011-1-21 由于抵用券表downloads_count有误  临时追加 include coupon_downloads
    @coupons = Coupon.paginate(
      :all,
      :joins => joins,
      :select => "coupons.*, coupons.pv as coupon_pv, distributors.title as coupon_distributor_title",
      :order => "coupons.downloads_count desc, coupons.id desc",
      :conditions => conditions,
      :include => [:coupon_confirmed_downloads, :coupon_downloads],
      :per_page => 20,
      :page => params[:page] && params[:page].to_i || 1
    )
  end
  
  # 排序
  def sort
    authorize! :sort, Coupon  
  end
 
  # == begin ==
  # 此处排序运用asct_as_list plugin
  def move
    authorize! :move, Coupon
    unless @coupon.blank?
      case params[:direction]
      when "top"
        @coupon.move_to_bottom
      when "bottom"
        @coupon.move_to_top    
      when "lower"
        @coupon.move_higher
      when "higher"
        @coupon.move_lower
      when "remove"
        @coupon.update_attribute(:priority, nil)
      else
      end
    end
    redirect_page
  end
 
  def insert_at
    authorize! :insert_at, Coupon
    if request.post?
      count = Coupon.ranked(params[:number].to_i)
      @coupon.insert_at(count, :asc) unless @coupon.blank?
    end
    redirect_page
  end

  #设置抵用券使用说明
  def set
    authorize! :set, Coupon
    if request.post?
      @set = ::Coupon.default_usage params[:set]
    else
      @set = ::Coupon.default_usage
    end
  end

  def on_line_display_amount
    authorize! :on_line_display_amount, Coupon
    if request.post?
      @amount = ::Coupon.on_line_display_amount params[:amount].to_i
    else
      @amount = ::Coupon.on_line_display_amount
    end
  end

  # ==  end ==

  def putonline
    authorize! :putonline, Coupon
    @coupon = ::Coupon.find(params[:id])
    @coupon.update_attribute(:status, 1)
    respond_to do |format|
      format.html { redirect_to(request.headers["HTTP_REFERER"] || admin_coupons_path) }
    end
  end

  # TODO desperate 第二版稳定后移除
  # 操作完成之后进行跳转之用
  def print_image_preview
    authorize! :print_image_preview, Coupon
    @coupon = ::Coupon.find(params[:id])

    properties = @coupon.print_properties
    @print_image = properties.clone
    # for properties no colors
    properties.delete "area_color"
    properties.delete "tag_color"
    print_property = CouponPrintProperty.find_by_coupon_id(@coupon.id) || CouponPrintProperty.create!(:coupon_id => @coupon.id, :properties => '""');
    print_property.update_attribute(:properties, properties.to_json)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # TODO desperate 第二版稳定后移除
  def print_image_confirm
    authorize! :print_image_confirm, Coupon
    @coupon = ::Coupon.find(params[:id])
    print_property = CouponPrintProperty.find_by_coupon_id(@coupon.id)
    properties = Yajl::Parser.parse(print_property.properties)
    @errors = {}
    properties.each do |k,v|
      if v.to_s.blank?
        @errors[k] = "信息缺失!"
      end
    end

    # 对日期进行校验
    end_date_str = properties["activity_end_at"]
    unless end_date_str.to_s.blank?
      end_date_str = end_date_str.gsub(/[年|月|日]/, '-').chomp("-")
      end_date = end_date_str.to_date
      if end_date < Time.zone.today
        if @errors.has_key? "activity_end_at"
          @errors[activity_end_at] = @errors[activity_end_at] + " :#{end_date_str} 已失效!"
        else
          @errors[activity_end_at] = ":#{end_date_str} 已失效!"
        end
      end
    end

    if @errors.size > 0
      render 'alert' 
      return
    else
      js = ""
      begin
        #        Resque::Job.create(:coupon_images, "Coupon::ImageGenerator::Job::SingleCoupon", @coupon.id)
        @coupon.update_attribute(:status, 1)
        js = "<script type='text/javascript'>\n"
        js << "alert(\"生成图请求成功发送,稍后将生成抵用券相关图片!\\n\\r在此生成图抵用券期间,请勿重复确认,谢谢!\\n\\r点 确定 返回列表页。\");\n"
        js << "location.href='#{admin_coupons_path}';\n"
        js << "</script>\n"
      rescue Exception => e
        js = "<script type='text/javascript'>\n"
        js << "alert(\"生成图请求处理失败!\\n\\r错误信息: #{e.message}\\n\\r请记录错误信息并与管理员联系!\\n\\r点 确定 返回到该抵用券对应编辑页面.\");\n"
        js << "location.href='#{edit_admin_coupon_path(@coupon)}';\n"
        js << "</script>\n"
      end
      render :text => js
      return
    end
  end

  def entrust
    authorize! :entrust, Coupon
    @coupon = ::Coupon.find(params[:id])

    # 更新打印属性
    properties = @coupon.print_properties
    # for properties no colors
    properties.delete "area_color"
    properties.delete "tag_color"
    print_property = CouponPrintProperty.find_by_coupon_id(@coupon.id) || CouponPrintProperty.create!(:coupon_id => @coupon.id, :properties => '""')
    print_property.update_attribute(:properties, properties.to_json)

    @agreement = CouponEntrustAgreement.find_by_coupon_id(params[:id]) || CouponEntrustAgreement.create(:coupon_id => params[:id], :status => 0)
    # 首次 需要生成
    if @agreement.status == 0
      @agreement.update_attribute(:status, 2)
      Resque::Job.create(:coupon_images_two, "Coupon::ImageGenerator::Job::SingleCouponV2", @agreement.coupon_id)
    end

    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
    end
  end

  def entrust_regen
    authorize! :entrust, Coupon
    @agreement = CouponEntrustAgreement.find_by_coupon_id(params[:id]) || CouponEntrustAgreement.create(:coupon_id => params[:id], :status => 0)
    @agreement.update_attribute(:status, 2)
    Resque::Job.create(:coupon_images_two, "Coupon::ImageGenerator::Job::SingleCouponV2", @agreement.coupon_id)
    redirect_to entrust_admin_coupon_path(@agreement.coupon_id)
  end

  # 更改现金券的销售方式：0默认现在的，1秒杀
  def sell_style
    flash[:success] = nil
    authorize! :second_killing, Coupon
    @coupon = ::Coupon.find(params[:id])
    if params[:sell_style]
      @coupon.update_attribute(:sell_style, params[:sell_style])
      flash[:success] = "操作已成功"
    end
  end

  # ===== private methods =====
  # 重定向到请求的地址
  def redirect_page
    redirect_to request.env["HTTP_REFERER"] || sort_admin_coupons_path
  end
  private :redirect_page
  
  # 得到所有优惠券信息
  def load_coupons
    @name = params[:name]
    @order = params[:order].to_i
    @priority = params[:priority].to_i
    @tag_id = params[:tag_id].to_i
    @city_id = params[:city_id].to_i
    @page = params[:page] && params[:page].to_i || 1
    @per_page = 20
    @count = (@page == 0 || @page == 1) ? 0 : ((@page - 1) * @per_page)
    @coupons = ::Coupon.with_period.by_tag_id(@tag_id).with_title_code(@order, @name).with_priority(@priority).with_city(@city_id)
    if can? :read, Coupon# do nothing prevent administrator manage all permission

    elsif can? :read_owned_coupons, :coupons
      @coupons = @coupons.with_contracts(current_ability_user.owned_contracts)
    else
      raise CanCan::AccessDenied
    end
    @coupons = @coupons.paginate :order => "priority DESC, activity_began_at DESC",
      :per_page => @per_page,
      :page => @page
  end
  private :load_coupons
  
  # 查询某一个优惠券信息
  def find_coupon
    @coupon = ::Coupon.find_by_id params[:coupon_id], :include => [:distributor, :tag, :brand]
  end 
  private :find_coupon
end
