# encoding: utf-8

# Front_Page coupon_controller 

class CouponsController < CouponApplicationControllerController
  # include ActionView::Helpers::DateHelper

  before_filter :validate_coupon_status, :only => [:show_v2, :print, :print_count, :recommended, :save_recommended]
  after_filter :set_browsed_coupons, :only => [:show_v2]
  after_filter :update_pv, :only => [:show_v2]
  after_filter :update_print, :only => [:print_count]
  skip_filter :auto_expire, :only => [:preview, :show, :show_v2, :promotion_industry]


  # 推荐行业的推广位
  def promotion_industry
    if params[:industry_name]
      coupons_ids = PromotionCollection.published_items_for("抵用券:频道首页:#{@city.pinyin}:推荐行业:#{params[:industry_name]}").map(&:url)
      coupons_ids.compact!
      @coupons = Coupon.find(:all, :conditions => ["id in (?)", coupons_ids ])
      @coupons = coupons_ids.collect do |id|
        @coupons.detect {|coupon| id.to_i == coupon.id }
      end
      respond_to do |format|
        format.html { render :layout => false }
      end
    else
      respond_to do |format|
        format.html { render :text => "" }
      end
    end
  end

  # 抵用卷频道首页
  def home
    @adspace_page = "抵用券-#{@city.name}-首页"
  end

  # 抵用券首页
  def index_v2
    @adspace_page, @order, @keyword = "抵用券-#{@city.name}-首页", params[:order].to_i, params[:keyword]
    @tag_id, @pc_id, @brand_id, @tag_options, @pc_options, @brand_options = Coupon.get_search_options(params[:tag_id].to_i, params[:pc_id].to_i, params[:brand_id].to_i)
    @district_id, @bz_id, @shop_id, @district_options, @bz_options, @shop_options, @market_options = Coupon.get_area_search_options(params[:district_id].to_i, params[:bz_id].to_i, params[:shop_id].to_i, @city.id)

    coupon_search = CouponSearch.new(@tag_id, @pc_id, @brand_id, @district_id, @bz_id, @shop_id, @city.id, @keyword)
    coupon_search.page = page
    coupon_search.order = @order
    @coupons = coupon_search.search

    render :action => :no_results if @coupons.length == 0
  end

  # 抵用卷频道首页
  def no_results; end

  # 新版终端页
  def show_v2
    @adspace_page = "抵用券-#{@city.name}-终端页"
    @remarks = @coupon.coupon_remarks.paginate(:all, :conditions => 'parent_id is null', :order => 'id desc', :page => page, :per_page => 5, :include => :user)
    @remark = @coupon.coupon_remarks.new
    render :action => :member_show unless Distributor::HuiYuan.find_by_id(@coupon.distributor.id).blank?
  end

  def member_show; end

  # 抵用券首页
  def index
    @adspace_page = "抵用券-#{@city.name}-首页"
    @order = params[:order].to_i
    @keyword = params[:keyword]
    @tag_id, @pc_id, @brand_id, @tag_options, @pc_options, @brand_options = Coupon.get_search_options(params[:tag_id].to_i, params[:pc_id].to_i, params[:brand_id].to_i)
    @district_id, @bz_id, @shop_id, @district_options, @bz_options, @shop_options, @market_options = Coupon.get_area_search_options(params[:district_id].to_i, params[:bz_id].to_i, params[:shop_id].to_i, @city.id)

    coupon_search = CouponSearch.new(@tag_id, @pc_id, @brand_id, @district_id, @bz_id, @shop_id, @city.id, @keyword)
    coupon_search.page = page
    coupon_search.order = @order
    @coupons = coupon_search.search

    # 抵用券线下按区域领取
    @districts = @city.districts
    @city_default_leaflet = {}
    if $redis.exists(CouponLeafletPoint.city_default_redis_key(@city.name))
      @city_default_leaflet = YAML::load($redis.get(CouponLeafletPoint.city_default_redis_key(@city.name)))
    end
    @leaflet_points = CouponLeafletPoint.all(:conditions => ["district_id in (?) and city_id = ? and activity_begin_at <= ? and activity_end_at >= ? ", @districts.map(&:id), @city.id, Time.zone.today, Time.zone.today]).group_by(&:district_id)

    render :action => :resultless if @coupons.length == 0
  end

  # Q&A
  def help; end

  # 排行榜
  def top; end
 
  # 抵用请终端页
  def show
    @adspace_page = "抵用券-#{@city.name}-终端页"
    @decofirm = @coupon.distributor.deco_firm
    @remarks = @coupon.coupon_remarks.paginate(:all, :conditions => 'parent_id is null', :order => 'id desc', :page => page, :per_page => 5, :include => :user)
    @remark = @coupon.coupon_remarks.new
  end


  # 查看装修公司
  def decofirm
    @decofirm = DecoFirm.find(params[:id])
    @associated = DistributorDecofirm.find_by_deco_firm_id(@decofirm.id)
    @distributor = @associated.distributor
    @cases = @decofirm.cases.find(:all, :limit=>8)
    @store_photo = @decofirm.store_photos.first
    @coupons = @distributor.coupons 
  end  

  # 预览
  def preview; end
  # 打印
  def print; end

  def print_count
    if request.xhr?
      begin
        render :json => {:success  => '1'}
      rescue
        render :json => {:success  => '0'}
      end
    end
  end

  # 推荐抵用
  def recommended; end

  # 保存推荐
  def save_recommended
    if request.post?
      emails = params[:emails]
      unless emails.blank?
        emails.each do |k, v|
          unless v.blank?
            CouponRecommendation.create(:email => v, :name => params[:names][k], :coupon => @coupon)
          end
        end
      end
    end
    redirect_to coupon_show_path(@coupon)
  end

  # 订阅抵用券
  def subscribe
    if subscribe = params[:coupon_subscribe]
      @subscribe = CouponSubscribe.new(subscribe)
      @subscribe.save ? @noticle = '订阅成功！' : @noticle = '订阅信息保存失败！'
    end
  end

  # 搜索无结果
  def resultless; end

  # 保存浏览过的抵用卷记录
  def set_browsed_coupons
    id = params[:id]
    return unless id
    id = id.to_i
    browsed_coupons = (cookies[:browsed_coupons] || '').split(',').map(&:to_i)
    browsed_coupons.delete id
    browsed_coupons.unshift id
    browsed_coupons = browsed_coupons[0...5] # 只保存最新的五次浏览记录
    cookies[:browsed_coupons] = browsed_coupons.join(',')
    true
  end

  def update_pv
    @coupon.increase_count!({:key => 'pv'})
  end
  private :update_pv

  def update_print
    @coupon.increase_count!({:key => 'print'})
  end
  private :update_print
end
