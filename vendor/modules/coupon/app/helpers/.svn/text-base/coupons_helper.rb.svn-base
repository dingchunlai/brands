module CouponsHelper

  def query_coupon_index(merge_key = nil, merge_value = nil, merge_key2 = nil, merge_value2 = nil, merge_key3 = nil, merge_value3 = nil)
    if @params_hash.nil?
      pa = ['tag_id', 'pc_id', 'brand_id', 'district_id', 'bz_id', 'shop_id']
      @params_hash = {}
      pa.each do |p|
        @params_hash.store(p.to_sym, eval("@#{p}")) if eval("@#{p}").to_i > 0
      end
    end
    ph = @params_hash
    ph = ph.merge({merge_key.to_sym => merge_value}) unless merge_value.nil?
    ph = ph.merge({merge_key2.to_sym => merge_value2}) unless merge_value2.nil?
    ph = ph.merge({merge_key3.to_sym => merge_value3}) unless merge_value3.nil?
    if ph[:keyword]
      coupon_search_path(ph)
    else
      coupon_scope_path(ph)
    end
  end

  # 合成抵用卷图片
  def coupon_image_url(coupon)
    image_url = coupon.is_a?(Coupon) ? coupon.image_url : coupon
    unless image_url.blank?
      File.join(cloud_fs_domain('image'), image_url)
    else
      "http://js.51hejia.com/img/nil.gif"
    end
  end

  def select_items_for_search
    search_items_name = []
    search_items_zh = ['行业', '产品', '品牌', '地区', '商圈', '分店']
    search_items_tag = ['tag_id', 'pc_id', 'brand_id', 'district_id', 'bz_id', 'shop_id']
    search_items = [@tag_id, @pc_id, @brand_id, @district_id, @bz_id, @shop_id]
    search_items_name << (tag_name = (@tag_id == 0 ? nil : Industry.get_tagname_by_tagid(@tag_id)))
    search_items_name << (pc_name = (@pc_id == 0 ? nil : ProductionCategory.id_to_name(@pc_id)))
    search_items_name << (brand_name = (@brand_id == 0 ? nil : Brand.id_to_name(@brand_id)))
    search_items_name << (district_name = (@district_id == 0 ? nil : District.id_to_name(@district_id)))
    search_items_name << (bz_name = (@bz_id == 0 ? nil : BusinessZone.id_to_name(@bz_id)))
    search_items_name << (shop_name = (@shop_id == 0 ? nil : MarketShop.id_to_name(@shop_id)))
    #[search_items, search_items_tag, search_items_zh, search_items_name ]
    @seo_scopes = [@city.name, district_name, bz_name, shop_name, tag_name, brand_name, pc_name].compact
    select_items = []
    search_items.each_with_index do |e, index|
      if e != 0
        url = case search_items_tag[index]
        when 'tag_id'
          query_coupon_index('tag_id', 0, 'pc_id', 0, 'brand_id', 0)
        when 'pc_id'
          query_coupon_index('pc_id', 0, 'brand_id', 0)
        when 'district_id'
          query_coupon_index('district_id', 0, 'bz_id', 0, 'shop_id', 0)
        when 'bz_id'
          query_coupon_index('bz_id', 0, 'shop_id', 0)
        else
          query_coupon_index(search_items_tag[index], 0)
        end
        select_items << {:title => search_items_zh[index], :value => search_items_name[index].to_s, :url => url}
      end
    end
    select_items
  end

end
