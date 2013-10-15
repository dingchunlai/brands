class Dianping::CouponsController < Dianping::ApplicationController
 
  before_filter :validate_coupon, :only => [:show]
  before_filter :vaildates_dianping_zhongduan_with_subdomain, :only => [:show, :coupon]
  caches_action :coupon, :expires_in => 5.minutes
  
  # DecoEvent list page
  def index
    @fragment_key = "dianping:coupons:index:#{@user_city_code}:#{params[:firm_name]}:#{params[:coupon_title]}:#{params[:date]}:#{params[:page]}" 
    @page = params[:page] ||= 1
    @firm_name ,@coupon_title ,@date = params.values_at(:firm_name ,:coupon_title ,:date) 
    unless fragment_exist? @fragment_key
      @coupons = DecoEvent.coupon_lists(@user_city_code,params).paginate :page => @page, :per_page => 6
    end
  end
  
  # Coupon list page 
  def coupons
    @page = params[:page] ||= 1
    @fragment_key = "dianping:coupons:coupons:#{@user_city_code}:#{@page}"
    unless fragment_exist? @frangment_key
      # 装修点评跟现金劵存贮城市不一致则需要将城市重新处理一次
      city = City.find_by_pinyin TAGURLS[@user_city_code.to_i]
      @coupons = Coupon.valid.with_city(city.id).has_firm_coupons.paginate :page => @page, :per_page => 12
    end
  end

  # DecoEvent show page
  def show
    @firm = DecoFirm.published.find_by_id @firm_id
    @remarks = @event.blank? ? [] : @event.show_remarks.paginate(:page => page, :per_page =>10)
    distributor_firm = DistributorDecofirm.find_by_deco_firm_id @firm_id, :include => {:distributor => :coupons}
    unless distributor_firm.blank?
      @coupon = distributor_firm.distributor.coupons.valid.to_a.last
    end
  end

  # Coupon show page 
  def coupon
    @coupon = Coupon.valid.find_by_id params[:id], :include => [{:distributor => :coupons}, :distributor_shop]
    # 某抵用卷是否帮定 装修公司
    return head 404 if @coupon.blank? || @coupon.distributor.deco_firm.blank?
    @firm = DecoFirm.published.find @coupon.distributor.deco_firm.id
    @event = @firm.events.count > 0 ? @firm.events[0] : nil
    @remarks = @event.blank? ? [] : @event.show_remarks.paginate(:page => page, :per_page =>10)
  end

  private

    # 验证加载 DecoEvent _object
    def validate_coupon
      @event_id = params[:id]
      @event = DecoEvent.find :first, :conditions => ["id = ? and ends_at >= ?", @event_id, Time.now.to_s(:db)]
      if @event.nil?
        head 404
      else
        if @event.firms
          @event.firms.size > 0 ? @firm_id = @event.firms[0].id : head(404)
        else
          head 404
        end
      end
    end
  
end
