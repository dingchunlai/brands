include ApplicationHelper
class ArticlesController < ApplicationController

  # skip_filter :auto_expire, :if => lambda { |controller| controller.params[:id].to_s.include?("preview") }
  def detail
    @is_preview = params[:id].to_s.include?("preview")
    return render :text => '提示：您没有权限访问预览界面！' if @is_preview && (!staff_logged_in? && RAILS_ENV == 'production')
    @id = params[:id].to_s.sub("_preview", "").to_i
    return page_not_found! unless @id > 0
    @channel = params[:channel]
    @article = Article.get_article(@id)
    return page_not_found! if @article.nil? || @article.article_sort.nil?
    return render :text => '提示：非预览模式无法浏览未发布的文章！' if @article.STATE != 0 && !@is_preview
    return redirect_301_to(@article.detail_url(@is_preview, params[:page])) if @article.detail_url(@is_preview) != current_url #如果当前url不正确，则跳转到正确的终端页地址。
    expires_now
    if @article.number.to_i == 0
      @article.number = rand(100)
      @article.save
    end
    @article.number += 1
    @article.save
    contents = @article.content && @article.content.CONTENT.to_s.split("{==PAGE-BREAK==}") || []
    if params[:page] == 'all'
      @contents = [contents.join]
      @article_total_pages = 1
    else
      @contents = contents.paginate :page => page, :per_page => 1
      @article_total_pages = @contents.total_pages
    end
    @contents[0] = article_content_filter(@contents[0])
    @contents_already_has_link = @contents[0].to_s.include?('<a ')
    get_remote_city
    @city_name = cookies[:api_city]
    @city_id = CITIES.invert[@city_name].to_i
    @city_id ? @city_id : @city_id = 11910

    if [11910, 11905, 11887, 11908].include? @city_id
      city_sql = "deco_firms.city = #{@city_id}"
    else
      city_sql = "deco_firms.district = #{@city_id}"
    end

    if TUI_API.keys.include? @city_name
      @tui_city = @city_name
    else
      @tui_city = "上海"
    end

    unless fragment_exist? "articles:#{@channel}:right:diary:#{@city_id}"
      if ["宁波","杭州","无锡","南京"].include?(@city_name.to_s)
        @diary_api = DecorationDiary.find(:all, :conditions => ["is_good = ? and (district = ? or city = ?)", 1, @city_id, @city_id], :order => "updated_at desc", :limit => 7)
      else
        @diary_api = DecorationDiary.find(:all, :conditions => ["is_good = ? and city = 11910", 1], :order => "updated_at desc", :limit => 7)
      end
      @tag_diaries = @diary_api[2, 8]
    end

    unless fragment_exist? "articles:#{@channel}:right:case:#{@city_id}"
      if ["宁波","杭州","无锡","南京"].include?(@city_name.to_s)
        @case_api = HejiaCase.find(:all, :joins => "join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id", :conditions => ["HEJIA_CASE.ISCHOICENESS = ? and (deco_firms.city = ? or deco_firms.district = ?)", 1, @city_id, @city_id], :order => "HEJIA_CASE.CREATEDATE desc", :limit => 7)
      else
        @case_api = HejiaCase.find(:all, :joins => "join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id", :conditions => ["HEJIA_CASE.ISCHOICENESS = ? and (deco_firms.city = 11910 or deco_firms.district = 11910)", 1], :order => "HEJIA_CASE.CREATEDATE desc", :limit => 7)
      end
    end

    unless fragment_exist? "articles:#{@channel}:bottom:#{@city_id}"
      random_firms = DecoFirm.find(:all, :conditions => "is_cooperation = 1 and #{city_sql}", :order => 'praise desc', :limit => 10)
      random_firms = DecoFirm.find(:all, :conditions => city_sql, :order => 'praise desc') unless random_firms
      random_firms = DecoFirm.find(:all, :order => 'praise desc') unless random_firms
      random_firm = random_firms[rand(10)]

      random_firm_case = HejiaCase.find(:first, :select => 'ID', :conditions => "COMPANYID = #{random_firm[:id]} and STATUS != '-100' and category = 0 and EXISTS (select * FROM photo_photos as p WHERE p.case_id = HEJIA_CASE.ID)", :order => 'LASTMODIFYTIME DESC')
      case_count_r = HejiaCase.find(:all, :select => "count(ID) as count_all", :conditions => "COMPANYID = #{random_firm[:id]} and STATUS != '-100'")
      diary_count_r = DecorationDiary.find(:all, :select => "count(ID) as count_all", :conditions => "deco_firm_id = #{random_firm[:id]} and status = 1")
      q_time = Time.now
      factory_count_r = CaseFactoryCompany.find(:all, :select => "count(ID) as count_all", :conditions => ["COMPANYID = #{random_firm[:id]} and (ENDENABLE > ? or STARTENABLE > ?)", q_time, q_time])
      all_applicant_count_r = Applicant.find(:all, :select => 'count(id) as count_all', :conditions => "deco_firm_id = #{random_firm.id} and status = 1")
      firm_applicant_count = Applicant.find(:all, :select => 'id', :conditions => "deco_firm_id = #{random_firm.id} and confirm_at >'#{1.month.ago.to_date.to_s}'").size

      @random_firm_info ||= {
          :company => random_firm,
          :company_case => random_firm_case,
          :cases_count => case_count_r[0].count_all,
          :decoration_diaries_count => diary_count_r[0].count_all,
          :factories_count => factory_count_r[0].count_all,
          :current_month_applicant_count => firm_applicant_count,
          :all_applicant_count => all_applicant_count_r[0].count_all
      }
    end

=begin

=end
    if @city_id.to_i == 11910
      @article.TODAY_PV = @article.TODAY_PV.to_i + 1
      @article.TOTAL_PV = @article.TOTAL_PV.to_i + 1
      @article.SH_TODAY_PV = @article.SH_TODAY_PV.to_i + 1
      @article.SH_TOTAL_PV = @article.SH_TOTAL_PV.to_i + 1
      @article.save
      @zcb = ZxMerchantBuy.find(:first,:conditions => ["article_id = ? and status=0", @article.ID])
      unless @zcb.blank?
        @designers = ZxDesigner.find(:all,:conditions => "merchant_id = #{@zcb.merchant_id}")
        @designer = @designers.rand
        @ads = ZxAd.find(:all,:conditions => "merchant_id = #{@zcb.merchant_id}")
        @ad = @ads.rand
        if params[:merchant_id].to_i != @zcb.merchant_id
          @zcb.art_today_view += 1
          @zcb.art_view += 1
          @zcb.save
          ZxTrend.create(:object_id => @article.ID, :object_type => 1, :title => @article.TITLE, :view_time => Time.now+8.hours, :user_ip => request.remote_ip)
          ZxShopVisit.create(:object_id => @article.ID, :object_type => 1, :title => @article.TITLE, :view_time => Time.now+8.hours, :user_ip => request.remote_ip, :shop_id => @zcb.merchant_id)
        end
      end
    end

    set_adspace_info
    render "detail_#{@article.template_name}"
  end
  
  def record_dynamic
    @article = Article.get_article(params[:article_id])
    @zcb = ZxMerchantBuy.find(:first,:conditions => ["article_id = ? and status=0", @article.ID])
    if params[:merchant_id].to_i != @zcb.merchant_id
      user_ip = request.remote_ip
      ZxTrend.create(:object_id => @article.ID, :title => @article.TITLE, :object_type => params[:dynamic_type], :view_time => Time.now+8.hours, :user_ip => user_ip)
      ZxShopVisit.create(:object_id => @article.ID, :title => @article.TITLE, :object_type => params[:dynamic_type], :view_time => Time.now+8.hours, :user_ip => user_ip, :shop_id => @zcb.merchant_id)
      @zcb = ZxMerchantBuy.find(params[:zcb_id])
      if params[:dynamic_type].to_i == 3
        @zcb.advs_today_view = @zcb.advs_today_view + 1
        @zcb.advs_view += 1
      end
      if params[:dynamic_type].to_i == 2
        @zcb.designers_today_view = @zcb.designers_today_view + 1
        @zcb.designers_view += 1
      end
      @zcb.save
    end

    render :text => "success"
  end

  def article_keywords
    @keywords = ZhuanquSort.find(:all, :select => "id,board_id,sort_name",
                                 :conditions => "is_delete = 0", :order => 'length(sort_name) desc')
    render :layout => false
  end
  
  def get_cities
    cities = []
    unless params[:provinces_id].blank?
      cities = ActiveRecord::Base.connection.select_all("SELECT * FROM 51hejia_php.public_citys where provinces_id=#{params[:provinces_id]}").map{|city|[city["name"],city["id"]]}
    end
    render :json => cities.to_json
  end
  
  def get_districts
    districts = []
    unless params[:citys_id].blank?
      districts = ActiveRecord::Base.connection.select_all("SELECT * FROM 51hejia_php.public_districts where citys_id=#{params[:citys_id]}").map{|city|[city["name"],city["id"]]}
    end
    render :json => districts.to_json
  end

  private

  def article_content_filter(content)
    return '' if content.blank?
    content = content.to_s.gsub("[swf]", "<embed src='")
    content = content.gsub("[/swf]", "' quality='high' width='480' height='400' align='middle' allowScriptAccess='allways' mode='transparent' type='application/x-shockwave-flash'></embed>")
    content = content.gsub("src=\"/UserFiles/Image", "src=\"http://image.51hejia.com/UserFiles/Image")
    content.gsub("src=\"/images/binary", "src=\"http://image.51hejia.com/images/binary")
  end

  def current_url
    server_name = request.env['HTTP_HOST'].to_s.split(':')[0]
    "http://#{server_name}/#{params[:channel]}/#{params[:date]}/#{params[:id]}"
  end

  def set_adspace_info
    # 获取广告相关信息
    @channel = @channel.to_s
    if @channel == "pinpaiku"
      if @article.tag
        @tag_name = '品牌库'
      end
    elsif @channel == 'xinwen'
      @tag_name = '行业新闻'
    elsif PRODUCT_ARTICLE_URL.keys.include?(@channel)
      @tag_name = '产品资讯-' + PRODUCT_ARTICLE_URL[@channel].to_s
    elsif FURNITURE_ARTICLE_URL.keys.include?(@channel)
      @tag_name = '家居资讯'
    else
    end
  end


  private

  def get_remote_city
    #return {:name => cookies[:api_city], :number => CITIES.invert[cookies[:api_city]]} if cookies[:api_city]
    user_ip = request.remote_ip
    #user_ip = "101.64.117.26"  # 宁波
    #user_ip = '222.73.180.146' # 上海 用于测试
    #user_ip = '122.224.185.6' # 杭州
    city = IpHelper.find_city_by_ip user_ip
    # 因为并非支持所有城市，如果城市不在支持的范围内，默认为上海
    unless city_id = CITIES.invert[city]
      city = "上海"
      city_id = CITIES.invert[city]
    end
    cookies[:api_city] = {:value => city, :expires => 1.month.from_now, :domain => ".51hejia.com"}
    {:name => city, :number => city_id, :pinyin => TAGURLS[city_id]}
  end
end
