class Dianping::HomeController < AutoExpireController
  
  include CityCode
   
  helper Dianping::ApplicationHelper
  skip_before_filter :get_promotion_items_for_layout, :brand_validation_filter
  before_filter :current_city_code
  before_filter :get_user_city_name,:only =>:index
  layout "dianping/application" 
   
  def index

    #中间滚动显示的内容,稍后看按城市查询
    query = if [11910,11905,31959,11908,11887].include? @user_city_code.to_i
      "deco_firms.city = #{@user_city_code.to_i} and deco_firms.name_abbr is not null and deco_firms.is_cooperation = 1"
    else
      "deco_firms.district = #{@user_city_code.to_i} and deco_firms.name_abbr is not null and deco_firms.is_cooperation = 1"
    end
    unless fragment_exist? "dianping:middle:roll:#{@user_city_code.to_i}:index"
      @from_diraies = DecorationDiary.find(:all,:select =>'decoration_diaries.id,substring(decoration_diaries.title,1,17) as title,decoration_diaries.deco_firm_id,decoration_diaries.updated_at,deco_firms.name_abbr as name_abbr',:joins =>'join deco_firms on decoration_diaries.deco_firm_id = deco_firms.id',:conditions =>query,:order =>'decoration_diaries.updated_at desc',:limit =>4)
      @from_cases = HejiaCase.find(:all,:select =>'HEJIA_CASE.ID,substring(HEJIA_CASE.NAME,1,17) as NAME,HEJIA_CASE.COMPANYID,HEJIA_CASE.lastmodifytime as updated_at,deco_firms.name_abbr as name_abbr',:joins =>'join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id',:conditions =>"(HEJIA_CASE.COMPANYID > 0 and HEJIA_CASE.COMPANYID != 7 and deco_firms.is_cooperation = 1) and #{query}",:order =>'HEJIA_CASE.lastmodifytime desc',:limit =>4)
      @from_remarks = Remark.find(:all,:select =>'remarks.id,substring(remarks.content,1,17) as content,remarks.resource_type,remarks.resource_id,remarks.updated_at',:joins =>'join deco_firms on remarks.resource_id = deco_firms.id',:conditions =>"(remarks.resource_type='DecoFirm' and remarks.resource_id > 0 and LENGTH(trim(remarks.content)) > 1 and remarks.status = 1 and deco_firms.is_cooperation = 1) and #{query}",:order =>'remarks.updated_at desc',:limit =>4)
      @from_all = @from_diraies + @from_cases + @from_remarks
    end

    unless fragment_exist? "dianping:middle:zhuangxiujingli:#{@user_city_code.to_i}:index"
      if FOLLOW_CITY.include? @user_city_code.to_i
        @api_diaries1 = DecorationDiary.get_firm_diary_by_price(query,1,4)
        @api_diaries2 = DecorationDiary.get_firm_diary_by_price(query,2,4)
        @api_diaries3 = DecorationDiary.get_firm_diary_by_price(query,3,4)
      else
        diary_api1 = hejia_promotion_items(NEW_DIANPING_HOME_API[@visitor_city_name]['网友装修经历']['8万以下'],:select =>'title',:limit =>4)
        diary_api2 = hejia_promotion_items(NEW_DIANPING_HOME_API[@visitor_city_name]['网友装修经历']['8-15万'],:select =>'title',:limit =>4)
        diary_api3 = hejia_promotion_items(NEW_DIANPING_HOME_API[@visitor_city_name]['网友装修经历']['15万以上'],:select =>'title',:limit =>4)

        b_proc = proc {|b_p| b_p.to_i}
        d1 = diary_api1.map(&:title).map &b_proc
        d2 = diary_api2.map(&:title).map &b_proc
        d3 = diary_api3.map(&:title).map &b_proc
        @api_diaries1 = DecorationDiary.find(:all,:conditions =>["id in (?)",d1],:order =>"find_in_set(id,'#{d1.join(',')}')")
        @api_diaries2 = DecorationDiary.find(:all,:conditions =>["id in (?)",d2],:order =>"find_in_set(id,'#{d2.join(',')}')")
        @api_diaries3 = DecorationDiary.find(:all,:conditions =>["id in (?)",d3],:order =>"find_in_set(id,'#{d3.join(',')}')")
      end

      #@api_diaries1 = @api_diaries1.sort_by {|ad1| d1.index(ad1.id)}
      #@api_diaries2 = @api_diaries2.sort_by {|ad2| d2.index(ad2.id)}
      #@api_diaries3 = @api_diaries3.sort_by {|ad3| d3.index(ad3.id)}
    end

    unless fragment_exist? "dianping:middle:zhuangxiuanli:#{@user_city_code.to_i}:index"
      if FOLLOW_CITY.include? @user_city_code.to_i
        @anlies = HejiaCase.find(:all,:include =>[:deco_firm,:designer],:conditions =>"#{query} and HEJIA_CASE.COMPANYID > 0 and HEJIA_CASE.COMPANYID != 7 and HEJIA_CASE.STATUS = '050'",:order =>"HEJIA_CASE.LASTMODIFYTIME desc",:limit =>4)
      else
        @anli_api = hejia_promotion_items(NEW_DIANPING_HOME_API[@visitor_city_name]['案例灵感'],:select =>'title',:limit =>4)
        anli_api_id = @anli_api.map(&:title).map {|aai| aai.to_i}
        @anlies = HejiaCase.find(:all,:include =>[:deco_firm,:designer],:conditions =>["ID in (?)",anli_api_id],:order =>"find_in_set(ID,'#{anli_api_id.join(',')}')")
      end
    end

    unless fragment_exist? "dianping:city_shouye:right_cuxiaohuodong:#{@user_city_code.to_i}:index"
      @coupons = DecoEvent.cooperation_coupon_lists(@user_city_code.to_i,nil)
    end
    
    #公司top 10

    #杭州，无锡，按正常口碑分排序调用
    #苏州和宁波的是api推广
    #上海是推荐位加上
    # **** star ****
    unless fragment_exist? "dianping:city_shouye:#{@user_city_code.to_i}:index"
      if [12117, 12301, 12306,12118].include?(@user_city_code.to_i)
        # 6万以下 / 8万以下
        firm_ids_top_ten_1 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[@visitor_city_name]['8万以下公司TOP10'], :attributes => ['title','url'],:limit => 10 )
        @firms_top_ten_1 = []
        firm_ids_top_ten_1.each do |firm|
          deco_firm = DecoFirm.find_by_id(firm.title)
          deco_firm.is_promoted = true if firm.url == "true"
          @firms_top_ten_1 << deco_firm
        end
      
        #6-10万 / 8-15万
        firm_ids_top_ten_2 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[@visitor_city_name]['8-15万公司TOP10'], :attributes => ['title','url'],:limit => 10 )
        @firms_top_ten_2 = []
        firm_ids_top_ten_2.each do |firm|
          deco_firm = DecoFirm.find_by_id(firm.title)
          deco_firm.is_promoted = true if firm.url == "true"
          @firms_top_ten_2 << deco_firm
        end
      
        #10W以上 / 15W以上
        firm_ids_top_ten_3 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[@visitor_city_name]['15-30万公司TOP10'], :attributes => ['title','url'],:limit => 10)
        @firms_top_ten_3 = []
        firm_ids_top_ten_3.each do |firm|
          deco_firm = DecoFirm.find_by_id(firm.title)
          deco_firm.is_promoted = true if firm.url == "true"
          @firms_top_ten_3 << deco_firm
        end
      else
        price_1 = [DecoFirm::PRICE.index("8万以下")]
        price_2 = [DecoFirm::PRICE.index("8-15万")]
        price_3 = [DecoFirm::PRICE.index("15-30万"), DecoFirm::PRICE.index("30万-100万"), DecoFirm::PRICE.index("100万以上")]
      
        is_promoted = @user_city_code.to_i == 11910 ? true : false
        # 8万以下
        if [12093].include?(@user_city_code.to_i)
          @promoted_companies = DecoFirm.price_top_ten(price_1, @user_city_code, true, 10)
          @firms_top_ten_1 = @promoted_companies
          if @promoted_companies.size < 10
            @firms_top_ten_1 += DecoFirm.price_top_ten(price_1, @user_city_code, false, 10 - @promoted_companies.size)
            @firms_top_ten_1 = @firms_top_ten_1.flatten
          end
        else
          @firms_top_ten_1 = DecoFirm.price_top_ten(price_1, @user_city_code, is_promoted, 10)
        end
        # 8-15万
        @firms_top_ten_2 = DecoFirm.price_top_ten(price_2, @user_city_code, (@user_city_code.to_i == 12306 ? true : is_promoted), 10)
        # 15W以上
        @firms_top_ten_3 = DecoFirm.price_top_ten(price_3, @user_city_code, is_promoted, 10)
      
      end
    end
  end



  #点评首页表单提交
  def dianping_form_save
    fd = Fdata.new
    fd.isdelete = 0
    fd.formid = 185
    fd.userip = request.remote_ip
    fd.cdate = fd.udate = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    1.upto(8) do |i|
      if params[:"c#{i}"].nil? || params[:"c#{i}"].blank?
        return render(:text =>'notblank')
      else
        fd.send "c#{i}=",params[:"c#{i}"]
      end
    end
    if fd.save
      render :text =>'ok'
    else
      render :text =>'no'
    end

  end


  private

  def get_user_city_name
    @visitor_city_name = TAGURLS[@user_city_code.to_i]
    @visitor_city_name ? @visitor_city_name : 'shanghai'
  end

end
