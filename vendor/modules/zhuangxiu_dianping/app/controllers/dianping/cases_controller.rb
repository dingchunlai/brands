class Dianping::CasesController < Dianping::ApplicationController
  
  #caches_action :index, :expires_in => 5.minutes
  before_filter :vaildates_dianping_zhongduan_with_subdomain, :only => [:show]
 
  
  def index
    #现日记列表参数为检索条件params[:condition] 
    #其中检索条件condition为4个参数组成的字符串  room => 户型  ,  model => 装修方式  ,style => 装修风格 ,price => 装修价位
    #其中每根据索引对应的条件分别为 condition = {0 => model ,1 => style,2 => price,3 => room} 
    #为了方面以后增加或减少查询条件.现用变量condition_size来注明几个参数
    condition_size = 4
    condition = params[:condition].blank? ? ("0" * condition_size) : params[:condition]
    conditions = condition.split(//)
    @model = conditions[0]
    @style = conditions[1] 
    @price = conditions[2] 
    @room = conditions[3]

    @pay = case @price
    when '0' ; nil
    when '1' ; 11621
    when '2' ; 11623
    when '3' ; 11622
    when '4' ; 11644
    when '5' ; 41733
    end

    @fengge = case @style
    when '0' ; nil
    when '1' ; 4361
    when '2' ; 4367
    when '3' ; 4363
    when '4' ; 4362
    when '5' ; 6680
    when '6' ; 4360
    end

    @huxing = case @room
    when '0' ; nil
    when '1' ; 4355
    when '2' ; 41666
    when '3' ; 41667
    when '4' ; 41943
    when '5' ; 41669
    when '6' ; 4354
    end

    @fangshi = case @model
    when nil ; nil
    when '0' then nil
    when '1' then 4374
    when '2' then 4375
    when '3' then 4376
    else          41735
    end

    @use = nil
    conditions = ["HEJIA_CASE.STATUS!='-100' and HEJIA_CASE.ISNEWCASE=1 and HEJIA_CASE.TEMPLATE != 'room' and HEJIA_CASE.ISZHUANGHUANG='1' and HEJIA_CASE.DESIGNERID!=2291 and HEJIA_CASE.COMPANYID is not null and HEJIA_CASE.COMPANYID not in (4,7)"]
    conditions << "EXISTS (select * FROM photo_photos as p WHERE p.case_id = HEJIA_CASE.ID)"
    city_id = @user_city_code.to_i
    conditions << "EXISTS (select 1 from deco_firms where (deco_firms.city=#{city_id} or deco_firms.district=#{city_id}) and deco_firms.id = HEJIA_CASE.COMPANYID)"    
    conditions << "EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@pay} and link2.LINKTYPE='case' and link2.ENTITYID = HEJIA_CASE.ID)" if !@pay.nil?&&@pay.to_s!=''
    conditions << "EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@fengge} and link2.LINKTYPE='case' and link2.ENTITYID = HEJIA_CASE.ID)" if !@fengge.nil?&&@fengge.to_s!=''
    conditions << "EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@use} and link2.LINKTYPE='case' and link2.ENTITYID = HEJIA_CASE.ID)" if !@use.nil?&&@use.to_s!=''
    conditions << "EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@fangshi} and link2.LINKTYPE='case' and link2.ENTITYID = HEJIA_CASE.ID)" if !@fangshi.nil?&&@fangshi.to_s!=''
    conditions << "EXISTS (select * FROM HEJIA_TAG_ENTITY_LINK as link2 WHERE link2.TAGID = #{@huxing} and link2.LINKTYPE='case' and link2.ENTITYID = HEJIA_CASE.ID)" if !@huxing.nil?&&@huxing.to_s!=''

    @cases = Case.find(:all, :select => "HEJIA_CASE.ID,HEJIA_CASE.NAME,HEJIA_CASE.ischeck,HEJIA_CASE.COMPANYID", :conditions => conditions.join(' and '), :order => 'HEJIA_CASE.CREATEDATE desc').paginate :page => params[:page], :per_page => 24

    ## 装修案例Top10：调用规则为一周点击量最高的案例
    @topten_cases = HejiaCase.top_cases(@user_city_code)
    expires_in 5.minutes, :public => true
  end

  
  def show
    @case = HejiaCase.find(params[:id], :include => [:deco_firm, {:deco_firm => [:photos, :store_photos]}, :show_remarks, :designer, :tags, :photos])
    @remarks = @case.show_remarks.paginate(:all, :per_page => 10, :page => params[:page])
    @remark = Remark.new
    @firm = @case.deco_firm
    @designers = CaseDesigner.firm_case_designer(@firm.id, 2)
    @photos = @case.photos
    @firm_photos = @case.deco_firm.photos
    @firm_store_photos = @case.deco_firm.store_photos
    unless fragment_exist?("dianping:cases:#{@case.ID}:left") && fragment_exist?("dianping:cases:#{@case.ID}:right")
      @designer = @case.designer
      @cases = @firm.cases.find(:all,:limit => 10)
      @similar_cases = @case.similar_cases[0..9]
      @tags = Hash.new
      @cases_title = "该公司其他案例"
      @case.tags.each do |tag|
        @tags[tag.TAGFATHERID] = tag.TAGNAME
      end
    end
  end
  
  def up
    @case = HejiaCase.find(params[:id])
    @case.update_attribute(:CASEUP, @case.CASEUP + 1)
    render :text => @case.CASEUP
  end
  
  def down
    @case = HejiaCase.find(params[:id])
    @case.update_attribute(:CASEDOWN, @case.CASEDOWN + 1)
    render :text => @case.CASEDOWN
  end
  
  def downcase
    redirect_to "http://tuku.51hejia.com/zhuangxiu/tuku/down_case/params[:id]"
  end
  
end
