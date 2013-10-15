# encoding: utf-8
require_dependency 'coupon/admin_controller'
class Admin::CouponDownloadsController < Coupon::AdminController
  
  def index
    @coupon = Coupon.find_by_id params[:id]
    if can? :read, CouponDownload
      
    elsif can? :read_owned_coupon_downloads, :coupon_downloads
      unless current_ability_user.owned_contracts.include? @coupon.contract_id
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end

    unless @coupon.blank?
      @coupon_downloads = CouponDownload.with_coupon(@coupon)
    else
      redirect_to data_admin_coupons_path
    end
  end

  def update
    authorize! :update, CouponDownload
    if request.xhr?
      coupon_download = CouponDownload.find_by_id params[:id]
      coupon = Coupon.find(coupon_download.coupon_id)
      if can?(:read_owned_coupon_downloads, :coupon_downloads)
        unless current_ability_user.owned_contracts.include? coupon.contract_id
          raise CanCan::AccessDenied
        end
      else
        raise CanCan::AccessDenied
      end
      coupon_download.verify_mobile
      render :json => coupon_download
    else
      redirect_to data_admin_coupons_path
    end
  end

  def stat
    authorize! :stat, CouponDownload
    @cities = City.find(:all).collect { |item| [item.name, item.id] }
    @industries = Industry.all_categories.collect { |item| [item.TAGNAME, item.TAGID] }
    @markets = Market.all.collect { |item| [item.name, item.id] }
    @partners = PartnerShip.all.collect { |item| [item.name, item.code] }

    conditions = stat_query_conditions

    joins =  "join coupons on coupons.id=coupon_downloads.coupon_id "\
            "join distributor_shops on distributor_shops.id=coupons.shop_id "\
            "join distributors on distributors.id=coupons.distributor_id "\
            "join cities on cities.id=coupons.city_id "

        # 仅当用选择卖场时 关联查询
    unless params[:market_id].blank?
      joins << "right join market_shops on market_shops.id = distributor_shops.market_shop_id "\
            "join markets on markets.id = market_shops.market_id "
    end

    @cds = CouponDownload.paginate(
        :all,
        :joins => joins,
        :group => "coupon_downloads.coupon_id",
        :select => "cities.name as city_name, "\
            "distributors.title as distributor_name, "\
            "distributor_shops.name as shop_name, "\
            "coupons.id as coupon_id, "\
            "coupons.code as coupon_code, "\
            "coupons.title as coupon_title, "\
            "coupons.pv as coupon_pv, "\
            "coupons.prints_count as coupon_prints_count, "\
            "count(coupon_downloads.id) as downloads_count, "\
            "group_concat(concat(mobile, '', if(trim(is_confirm)='1', '(已)', '(未)'))) as user_mobiles",
        :order => "downloads_count desc",
        :conditions => conditions,
        :per_page => 20,
        :page => params[:page] && params[:page].to_i || 1
    )


    
    respond_to do |format|
      format.html {  }
    end
  end

  # 后期如有需要 再实现 按城市 按时间 按经销商 按门店等条件查询下载
  def stat_download
    authorize! :stat_download, CouponDownload
    attr2name = {
        "coupon_pv"           => '抵用券浏览次数',
        "coupon_id"           => '抵用券ID',
        "coupon_code"         => '抵用券编号',
        "city_name"           => '城市名称',
        "distributor_name"    => '经销商名称',
        "coupon_prints_count" => '抵用券打印次数',
        "user_mobiles"        => '下载用户手机号-确认状态',
        "shop_name"           => '经销商门店',
        "downloads_count"     => '手机下载次数',
        "coupon_title"        => '抵用券名称'
    }

    conditions = stat_query_conditions

    joins =  "join coupons on coupons.id=coupon_downloads.coupon_id "\
            "join distributor_shops on distributor_shops.id=coupons.shop_id "\
            "join distributors on distributors.id=coupons.distributor_id "\
            "join cities on cities.id=coupons.city_id "

    # 仅当用选择卖场时 关联查询
    unless params[:market_id].blank?
      joins << "right join market_shops on market_shops.id = distributor_shops.market_shop_id "\
            "join markets on markets.id = market_shops.market_id "
    end

    cds = CouponDownload.find(
        :all,
        :joins => joins,

        :group => "coupon_downloads.coupon_id",
        :select => "cities.name as city_name, "\
            "distributors.title as distributor_name, "\
            "distributor_shops.name as shop_name, "\
            "coupons.id as coupon_id, "\
            "coupons.code as coupon_code, "\
            "coupons.title as coupon_title, "\
            "coupons.pv as coupon_pv, "\
            "coupons.prints_count as coupon_prints_count, "\
            "count(coupon_downloads.id) as downloads_count, "\
            "group_concat(concat(mobile, '', if(trim(is_confirm)='1', '(已)', '(未)'))) as user_mobiles",
        :order => "downloads_count desc",
        :conditions => conditions
    )

    csv_data = FasterCSV.generate do |csv|
      csv << attr2name.keys.sort.collect { |key| attr2name[key] }
      cds.each do |cd|
        csv << attr2name.keys.sort.collect { |key| cd.send(key) }
      end
    end

    respond_to do |format|
      format.csv {
        send_data csv_data, :type => "text/csv;charset=utf-8; header=present",:filename => "抵用券手机下载信息_#{Time.now.strftime("%Y%m%d")}.csv"
      }
    end
  end

  private
  def stat_query_conditions
    conditions = ["1=1"]
    unless params[:date_begin].blank?
      conditions[0] << " and coupon_downloads.created_at >= ? "
      conditions << Time.zone.parse(params[:date_begin]).beginning_of_day
    end

    unless params[:date_end].blank?
      conditions[0] << " and coupon_downloads.created_at <= ? "
      conditions << Time.zone.parse(params[:date_end]).end_of_day
    end

    unless params[:confirm_status] == "全部"
      conditions[0] << " and coupon_downloads.is_confirm = ? "
      conditions << ((params[:confirm_status] == "已确认") ? 1 : 0)
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

    unless params[:cp_source].blank?
      unless params[:cp_source] == "-"
        conditions[0] << " and coupon_downloads.source = ? "
        conditions << "#{params[:cp_source]}"
      end
    end

    unless params[:coupon_id].blank?
      conditions[0] << " and coupon_downloads.coupon_id = ? "
      conditions << "#{params[:coupon_id]}"
    end

    unless params[:coupon_title].blank?
      conditions[0] << " and coupons.title like ? "
      conditions << "%#{params[:coupon_title]}%"
    end

    if can? :read, Coupon# do nothing prevent administrator manage all permission

    elsif can? :read_owned_coupons, :coupons
      conditions[0] << " and coupons.contract_id in (?) "
      conditions << current_ability_user.owned_contracts
    else
      raise CanCan::AccessDenied
    end
    conditions
  end

end
