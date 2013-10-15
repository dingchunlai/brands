class Dianping::FirmsController < Dianping::ApplicationController
  helper :all
  before_filter :validates_dianping_with_subdomain, :only => [:show]
  caches_action :bieshu, :expires_in => 5.minutes
  caches_action :gongzhuang, :expires_in => 5.minutes
  caches_action :free_loan, :expires_in => 5.minutes
  # 装修公司列表页面
  def index
    #现公司列表参数为params[:condition] params[:order]
    #排序为order ,检索条件为condition 
    #其中检索条件condition为4个参数组成的字符串  district => 地区  ,  model => 装修方式  ,style => 装修风格 ,price => 装修价位
    #其中每根据索引对应的条件分别为 condition = {0 => model ,1 => style,2 => price,3 => district} 
    #因为地区为不确定位数的数字.其它条件都为个位数,于是把district放在最后面.所以action处理params[:condition]这个参数时.分成两个部分.一部分为除district外的其它参数 ,另一部分为district.
    #为了方面以后增加或减少查询条件.现用变量condition_size来注明除district外的其它参数的个数.
    condition_size = 3 
    condition = params[:condition].blank? ? ("0" * (condition_size + 1)) : params[:condition] #为了避免没有条件时下截取报错
    @order = params[:order]  
    condition_exception_district = condition[0,condition_size].split(//)
    @model = condition_model = condition_exception_district[0]
    @style = condition_style = condition_exception_district[1]
    @price = condition_price = condition_exception_district[2]
    @district = condition_district = condition[condition_size..-1]
    promoted_firms = find_promoted_companies(condition,condition_size,@order)
    #按条件分类 公司top 10
    @assort_firms = []
    if promoted_firms.size > 0
      promoted_firms.each do |firm|
        firm.is_promoted = true
        @assort_firms << firm
      end
    end

    ## 获得当前城市最新合作前10公司,增加价格查询
    @newten_firms = DecoFirm.newten_firms(@user_city_code,@price)

    @assort_firms += DecoFirm.firms_by_assort_for(condition_model,condition_style,condition_price).by_city(@user_city_code).firms_by_cooperation_praise_for(promoted_firms.map{|firm| firm.id}, 10 - promoted_firms.count)
    if @assort_firms.size < 10
      @assort_firms = @assort_firms + DecoFirm.by_city(@user_city_code).firms_by_cooperation_praise_for(@assort_firms.map{|firm| firm.id},10 - @assort_firms.size ).find(:all , :select => "id,name_abbr, praise")
    end  
    #得到当前的参数
    # @district ,@model ,@style ,@order ,@price ,@hcase ,@hcommont ,@page = params.values_at(:district ,:model ,:style ,:order ,:price ,:hcase ,:hcommont ,:page)
    #关键字查询 
    if params[:keyword] && params[:keyword] != ''
      @promoted_companies =  []
      @companies = DecoFirm.firms_by_keyword_for(params[:keyword]).published.by_city(@user_city_code).paginate(:order => "is_cooperation desc, praise desc" , :page => params[:page],:per_page => 15)
    else
      #先查推荐位上的公司
      @promoted_companies = []      
      # 只有第一页才推广
      if params[:page].blank? || params[:page] == '1' || params[:page] == '0'
        @promoted_companies = promoted_firms
      end
      page = (params[:page] && params[:page].to_i == 0) ? 1 : params[:page]
      @order = 1 if (@user_city_code.to_i != 11910) && (@user_city_code.to_i != 11905) && (@user_city_code.to_i != 31959) && condition_model.to_i == 0 && condition_district.to_i == 0 && condition_style.to_i == 0 && condition_price.to_i == 0 && params[:order].to_i == 0  #除上海外其它城市默认排序为1
      
      promoted_firm_ids = promoted_firms.size == 0 ? '' : promoted_firms.map{|f|f.id}
      #原来的规则是标签下的公司排序，即
      #@companies = DecoFirm.firms_by_assort_for(params).firms_list_for(promoted_firm_ids,params,@user_city_code).published.firm_list_order_for(params[:order], @user_city_code)
      #而现在是三个部分（该标签下的合作公司+非该标签下的合作公司+该标签下的非合作公司）的排序，即
      cooperation_tag_firms = DecoFirm.firms_by_assort_for(condition_model,condition_style,condition_price).firms_list_for(promoted_firm_ids,condition_district,@user_city_code).published.is_cooperation.firm_list_order_for(params[:order], @user_city_code)
      cooperation_no_tag_firms = DecoFirm.firms_list_for(promoted_firm_ids,condition_district,@user_city_code).published.is_cooperation.firm_list_order_for(params[:order], @user_city_code)
      no_cooperation_tag_firms = DecoFirm.firms_by_assort_for(condition_model,condition_style,condition_price).firms_list_for(promoted_firm_ids,condition_district,@user_city_code).published.is_not_cooperation.firm_list_order_for(params[:order], @user_city_code)
      @companies = cooperation_tag_firms + (cooperation_no_tag_firms - cooperation_tag_firms) + no_cooperation_tag_firms
      #当companies当中没有合作公司时，则把该城市的所有合作公司排在前面，规则：按口碑从高到低排序，口碑一样的话应该是日记认证数量多的，和排行榜统一，请再确认下
      #firms_by_cooperation_praise_for这个方法一般只用于较少公司的显示8或10，而这里是用于公司列表页的，所以取目前上架公司的总和
      unless @companies.map(&:is_cooperation).include?(1)
        @companies = DecoFirm.firms_by_cooperation_praise_for(promoted_firm_ids, 12000).published.by_city(@user_city_code)
      end
      @companies = @companies.paginate :page => page, :per_page => 15
    end
    expires_in 5.minutes, :public => true
  end
  
  # 装修公司终端页
  def show
    flash[:notice] = nil
    @firm = DecoFirm.published.find(params[:id], :include => [:store_photos, :decoration_diaries, :factories, :quoted_prices, :glory_certificates, :deco_ideas, :show_remarks])
    
    # 在线申请
    @applicant = Applicant.new
    
    # 门店照片
    unless fragment_exist? "dianping:firms:store_photo:#{@firm.id}"
      @store_photos = @firm.store_photos
      @store_photos_count = @store_photos.size > 3 ? 3 : @store_photos.size
    end
    
    #页面左侧
    unless fragment_exist? "dianping:firms:left:#{@firm.id}"
      # 案例
      @cases = @firm.cases.find(:all, :conditions => "EXISTS (select * FROM photo_photos as p WHERE p.case_id = HEJIA_CASE.ID)", :order => "LIST_INDEX DESC", :limit=>4)
      # 案例数
      @cases_count = @firm.cases.count
      # 装修日记
      @diaries = @firm.decoration_diaries.published.find(:all, :limit => 4)
      # 装修日记数
      @diaries_count = @firm.decoration_diaries.published.count
      # 在建工地
      @factories = 
        if @firm.is_cooperation == 1
        @firm.factories.find(:all, :order => 'STARTENABLE desc', :limit => 4)
      else
        ""
      end
      # 在建工地数
      @factories_count = @firm.factories.count
      # 施工
      @photos = @firm.photos.find(:all, :limit => 4)
      # 活动信息
      @events =
        if @firm.is_cooperation == 1
        @firm.events.find(:all,:order => "created_at desc", :limit =>3 )
      else
        DecoEvent.find(:all,:order => "created_at desc", :limit => 3 )
      end
    end
    
    #页面右侧
    unless fragment_exist?  "dianping:firms:right:#{@firm.id}"
      # 常规报价
      @quoted_prices = @firm.quoted_prices
      # 设计师
      @designers = CaseDesigner.firm_case_designer(@firm.id, 6)
      # 荣誉证书
      @glory_certificates = @firm.glory_certificates
      # 设计理念
      @deco_ideas = @firm.deco_ideas.find(:all, :limit => 3)
      # 活动信息
      @events =
        if @firm.is_cooperation == 1
        @firm.events.find(:all,:order => "created_at desc", :limit =>3 )
      else
        DecoEvent.find(:all,:order => "created_at desc", :limit => 3 )
      end

      deco_dis = DistributorDecofirm.find_by_deco_firm_id(@firm.id)
      @coupons = unless deco_dis.blank?
        deco_dis.distributor.coupons.valid
      else
        [] 
      end
    end
    
    # 评论
    @remarks_user_count = @firm.show_remarks.map(&:user_id).uniq.size
    unless fragment_exist? "firm:remarks:#{@firm.id}:"
      @remarks = @firm.show_remarks.paginate(:all, :per_page => 10, :page => params[:page],:conditions => ["status=?", 1], :order => 'created_at desc')
    end
  end
  
  def save_deco_impression
    impression = DecoImpression.new :title => params[:title].gsub(/[,.\/\\?<>~，。／、]/,''), :deco_firm_id => params[:id], :session_id => request.session_options[:id]
    if impression.save
      #render :json => DecoImpression.latest(params[:id])
      @firm = DecoFirm.find params[:id]
      # 基于现有 条件 计算总数
      DecoImpression.sum_count(@firm.id)
      render :partial => "/dianping/firms/deco_impression_cloud"
    else
      render :json => impression.errors.full_messages, :status => 500
    end
  end

  def deco_impression_cloud_pop
    @firm = DecoFirm.find params[:id]
    render :partial => "/dianping/firms/impression_pop"
  end

  def top_deco_impression
    @firm = DecoFirm.find params[:id]
    render :partial => "/dianping/firms/top_deco_impression"
  end
  
  #获得修改前的路由，转向新的路由
  def firm_url_turn_to
    #params[:hcase] 和  params[:hcommont] 这两个参数不知道是干嘛的.
    #现好像没用到。估计 hcase是判断是否有案例,hcommont是判断是否有评论
    #现在没用到，为了兼容以前，还是加上去吧。
    district ,model ,style ,order ,price ,hcase ,hcommont ,page = params.values_at(:district ,:model ,:style ,:order ,:price ,:hcase ,:hcommont ,:page)
    page = page.blank? ? 1 : page
    url = "/zhuangxiugongsi-#{district.to_i}-#{model.to_i}-#{style.to_i}-#{order.to_i}-#{price.to_i}-#{hcase.to_i}-#{hcommont.to_i}-#{page}"
    redirect_301_to url
  end
  
  
  #工装列表页
  def gongzhuang
    @city_name = TAGURLS[@user_city_code.to_i]
    @page_title = 'decoration' #列表页的title为工装的title
    @page = params[:page] ||= 1
    @per_page = 10
    @alone = true
    promoted_array = PromotedFirm.find(:first, :conditions => ["city = ? and category = 1", @user_city_code.to_i])
    @promotes_ids =  promoted_array && promoted_array.firms_id ? promoted_array.firms_id : []
    conditions = []
    conditions << ((@user_city_code.to_i == 11910 || @user_city_code.to_i == 11905 || @user_city_code.to_i == 31959) ? "city = #{@user_city_code.to_i}" : "district = #{@user_city_code.to_i}")
    conditions << "state <> '-99' and state <> '-100' and category = 1"
    promotes = []
    promoted_array = PromotedFirm.find(:first, :conditions => ["city = ? and category = 1", @user_city_code.to_i])
    if promoted_array && promoted_array.firms_id
      promoted_array.firms_id.each do |id|
        promotes << DecoFirm.find_by_id(id)
      end
    end
    conditions << "id not in (#{promotes.map(&:id).join(',')})" if promotes.size > 0
    companys = DecoFirm.find(:all,:conditions => conditions.join(' and '),:order => "is_cooperation DESC , praise desc, (select count(*) from  decoration_diaries where deco_firms.id = decoration_diaries.deco_firm_id and decoration_diaries.status = 1 and decoration_diaries.is_verified = 1) desc")
    @firms = (promotes + companys).paginate(:page => @page, :per_page => @per_page)
    render "/dianping/firms/index" ,:layout => "dianping/application"
  end
  
  #别墅列表页
  def bieshu
    @page = params[:page] ||= 1
    @per_page = 10
    @alone = true
    @page_title = "villa" #列表页的title为别墅的title
    @city_name = TAGURLS[@user_city_code.to_i]
    promoted_array = PromotedFirm.find(:first, :conditions => ["city=? and villa=1",@user_city_code.to_i])
    @promotes_ids = promoted_array && promoted_array.firms_id ? promoted_array.firms_id : []
    conditions = []
    conditions << ((@user_city_code.to_i == 11910 || @user_city_code.to_i == 11905 || @user_city_code.to_i == 31959) ? "city = #{@user_city_code.to_i}" : "district = #{@user_city_code.to_i}")
    conditions << "state <> '-99' and state <> '-100' and villa = 1"
    promotes = []
    promoted_array = PromotedFirm.find(:first, :conditions => ["city=? and villa=1",@user_city_code.to_i])
    if promoted_array && promoted_array.firms_id
      promoted_array.firms_id.each do |id|
        promotes << DecoFirm.find_by_id(id)
      end
    end
    conditions << "id not in (#{promotes.map(&:id).join(',')})" if promotes.size > 0
    companys = DecoFirm.find(:all,:conditions => conditions.join(' and '),:order => "is_cooperation DESC , praise desc, (select count(*) from  decoration_diaries where deco_firms.id = decoration_diaries.deco_firm_id and decoration_diaries.status = 1 and decoration_diaries.is_verified = 1) desc")
    @firms = (promotes + companys).paginate :page => @page, :per_page => @per_page
    
    render "/dianping/firms/index" ,:layout => "dianping/application"
  end

  #免费贷款
  def free_loan
    @page = params[:page] ||= 1
    @per_page = 10
    #@alone = true
    @promoted_companies = []
    @city_name = TAGURLS[@user_city_code.to_i]
    conditions = []
    conditions << ((@user_city_code.to_i == 11910 || @user_city_code.to_i == 11905 || @user_city_code.to_i == 31959) ? "city = #{@user_city_code.to_i}" : "district = #{@user_city_code.to_i}")
    conditions << "state <> '-99' and state <> '-100' and free_loan = 1"
    @companies = DecoFirm.find(:all,:conditions => conditions.join(' and '),:order => "is_cooperation DESC , praise desc, (select count(*) from  decoration_diaries where deco_firms.id = decoration_diaries.deco_firm_id and decoration_diaries.status = 1 and decoration_diaries.is_verified = 1) desc").paginate :page => @page, :per_page => @per_page
    @order = 6
    render "/dianping/firms/index" ,:layout => "dianping/application"
  end
  
  # private  -------------------------分割线-------------------------------
  private
  # 推荐位公司
  def find_promoted_companies(condition,condition_size,order)
    promoted_companies = []
    # 收集当前的条件
    condition_exception_district = condition[0,condition_size].split(//)
    model = condition_exception_district[0]
    style = condition_exception_district[1]
    price = condition_exception_district[2]
    district = condition[condition_size..-1]
    
    order = 1 if order.to_i == 0
    #如果没有排序的参数,刚上海默认为1， 其它城市随机
    # if order.to_i == 0
    #     order = @user_city_code.to_i == 11910 ?  1 : 1 + rand(4)
    #   end
    # 公司的推广有两种情况：
    # 1. 包含：条件完全符合的，推广
    promoted = PromotedFirm.find_city(@user_city_code).find_order(order).find_price(price).find_style(style).find_model(model).find_district(district).find_except(0).first
    if !promoted.nil? && promoted.firms_id
      # 为了按指定顺序排序
      promoted.firms_id.each do |id|
        promoted_companies.concat DecoFirm.find :all, :conditions => {:id => id}
      end
    end
    # 2. 排除：只有当条件不符合时，才推广
    promoted_except = PromotedFirm.find_city(@user_city_code).find_except(1)
    if !promoted_except.blank?
      except_firm_ids = promoted_except.map{ |e| e.firms_id }.flatten
      except = PromotedFirm.find_city(@user_city_code).find_order(order).find_price(price).find_style(style).find_model(model).find_district(district).find_except(1).first
      except_firm_ids = except_firm_ids - except.firms_id unless except.nil?
      company_except = DecoFirm.find :all, :conditions => {:id => except_firm_ids}
      promoted_companies.concat company_except
    end
    promoted_companies
  end
  
end
