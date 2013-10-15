class IndexController < ApplicationController#AutoExpireController
  before_filter :get_promotion_items_for_index_layout

  def index
    has_image_article = Article.hot_spot_eveluating(0, 3, true)
    not_image_article = Article.hot_spot_eveluating(0, 8, false, has_image_article)
    @hot_spot_evaluating = {
      'has_image' => has_image_article,
      'not_image' => not_image_article
    } # 热点评测11条

    @brand_list = {
      "youqituliao" => Brand.last_month_tops_of(Tag["youqituliao"].TAGID, 5),
      "diban" => Brand.last_month_tops_of(Tag["diban"].TAGID, 5),
      "weiyu" => Brand.last_month_tops_of(Tag["weiyu"].TAGID, 5),
      "chufangdianqi" => Brand.last_month_tops_of(Tag["chufangdianqi"].TAGID, 5),
      "chugui" => Brand.last_month_tops_of(Tag["chugui"].TAGID, 5)
    }

    if params[:dont_cache_me] or params[:no_cache]
      expires_now
    else
      expires_in 10.minutes
    end

    get_remote_city[:name]

    @promotion_items['广告'] ||= {}
    @promotion_items['广告']['页头通栏'] = API_PROMOTION_MAPPING['广告']['页头通栏']['首页']

=begin
    if stale?(:last_modified => [last_modified_of_promotion_items(@promotion_items),(Rails.env == 'development' ? Time.now.utc : ::Brands::LAST_MODIFIED.utc)].max)
    end
=end
  end
  
  def articles
  end


  def reg_save
    callback = params[:callback]
    if params[:image_code].blank? || params[:image_code].to_s.strip != session[:image_code]
      return render :text => "#{callback}({'error':'code'})", :content_type => Mime::JS
    end
    hub = HejiaUserBbs.new
    hub.USERNAME = params[:username].strip
    hub.USERBBSEMAIL = params[:userbbsemail].strip
    hub.BBSID = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
    hub.USERTYPE = 1
    hub.USERBBSSEX = params[:gender] unless params[:gender].blank?
    hub.AREA = params[:area].strip unless params[:area].blank?
    hub.CITY = params[:city].strip unless params[:city].blank?
    hub.USERSPASSWORD = Digest::MD5.hexdigest(params[:userpassword].strip)
    hub.CREATTIME = Time.now
    hub.HEADIMG = "http://member.51hejia.com/images/headimg/default.gif"
    session[:image_code] = nil
    if hub.save
      login_user! hub
      render :text => "#{callback}('#{hub.USERBBSID}')", :content_type => Mime::JS
    else
      hub.valid?
      render :text => "#{callback}({'error':'#{hub.errors['USERNAME']}'})", :content_type => Mime::JS
    end
  end

  def get_image_code
    validate_image = ValidateImage.new(4)
    session[:image_code] = validate_image.code
    send_data(validate_image.code_image, :type => 'image/jpeg')
  end


  private
  def get_promotion_items_for_index_layout
    inject_promotion_items @promotion_items, '首页',
      ['热门品牌关键字'],
      ['友情链接']
  end

  def get_remote_city
    if params[:dont_cache_me].blank? and params[:no_cache].blank?
      return {:name => cookies[:api_city], :number => CITIES.invert[cookies[:api_city]] } if cookies[:api_city]
    end
    user_ip = request.remote_ip
    city = IpHelper.find_city_by_ip user_ip
    # 因为并非支持所有城市，如果城市不在支持的范围内，默认为上海
    unless city_id = CITIES.invert[city]
      city = '上海'
      city_id = CITIES.invert[city]
    end
    cookies[:api_city] = {:value => city, :expires => 1.month.from_now, :domain => ".51hejia.com"}
    {:name => city, :number => city_id, :pinyin => TAGURLS[city_id]}
  end
end
