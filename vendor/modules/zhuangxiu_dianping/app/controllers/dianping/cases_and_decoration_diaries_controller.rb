class Dianping::CasesAndDecorationDiariesController < Dianping::ApplicationController
  
  def index
    
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
    
    
    @lists = CaseAndDiary.find(:all,:select  => "id,item_id,item_type",:order => "order_time desc").paginate :page => params[:page] , :per_page => 10
  end

end