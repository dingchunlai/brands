class CouponSearch

  DEFAULT_CITY_ID = 1
  PER_PAGE = 21
  
  attr_accessor :keyword, :tag_id, :pc_id, :brand_id, :district_id, :bz_id, :shop_id, :city_id, :order, :per_page, :page

  def initialize(tag_id=0, pc_id=0, brand_id=0, district_id=0, bz_id=0, shop_id=0, city_id=0, keyword='')
    @tag_id, @pc_id, @brand_id, @district_id, @bz_id, @shop_id= tag_id, pc_id, brand_id, district_id, bz_id, shop_id
    @city_id = city_id==0 ? DEFAULT_CITY_ID : city_id
    @keyword = keyword
    @order, @per_page, @page = 0, PER_PAGE, 1
  end

  def get_distributor_shop_ids
    if @shop_id > 0
      conditions = ["market_shop_id = ?", @shop_id]
    elsif @bz_id > 0
      conditions = ["business_zone_id = ?", @bz_id]
    elsif @district_id > 0
      conditions = ["district_id = ?", @district_id]
    else
      conditions = ["city_id = ?", @city_id]
    end
    Distributor::Shop.find(:all, :select => 'id', :conditions => conditions).map{|s| s.id}
  end

  def order_by
    case @order
    when 1
      'created_at desc'
    when 2
      'downloads_count desc'
    when 3
      'activity_end_at asc'
    when 4
      'pv desc'
    when 5
      'discount_rate desc'
    else
      'commission desc, priority desc, discount_rate desc'
    end

  end

  def search
    coupons = Coupon.valid
    if @shop_id > 0 || @bz_id > 0 || @district_id > 0
      coupons = coupons.by_shops(get_distributor_shop_ids)
    else
      coupons = coupons.by_city(@city_id)
    end
    coupons = coupons.by_tag_id(@tag_id) if @tag_id > 0
    coupons = coupons.by_production_category_id(@pc_id) if @pc_id > 0
    coupons = coupons.by_brand_id(@brand_id) if @brand_id > 0
    coupons = coupons.with_title(@keyword) unless @keyword.blank?
    coupons.paginate :order => order_by, :include => [:distributor, :distributor_shop], :per_page => @per_page, :page => @page
  end

end
