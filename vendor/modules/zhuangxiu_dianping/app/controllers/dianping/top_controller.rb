class Dianping::TopController < Dianping::ApplicationController
  #include CityCode
  require "redis"
  #before_filter :current_city_code, :only => [:index]
  before_filter :validate_top_city,  :only => [:index]  #验证是否为上海
  caches_action :index, :expires_in => 5.minutes

  def index

    ## 苏州（12117）、无锡（12118）、宁波（12301）、杭州（12306）取API推广的
    if [12117, 12301, 12306,12118].include?(@user_city_code.to_i)
      firm_ids_top_ten_1 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[@user_city_code.to_i]]['8万以下公司TOP10'], :attributes => ['title','url'],:limit => 10 )
      @firms_top_8 = []
      firm_ids_top_ten_1.each do |firm|
        deco_firm = DecoFirm.find_by_id(firm.title)
        deco_firm.is_promoted = true if firm.url == "true"
        @firms_top_8 << deco_firm
      end
      firm_ids_top_ten_2 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[@user_city_code.to_i]]['8-15万公司TOP10'], :attributes => ['title','url'],:limit => 10 )
      @firms_top_8_15 = []
      firm_ids_top_ten_2.each do |firm|
        deco_firm = DecoFirm.find_by_id(firm.title)
        deco_firm.is_promoted = true if firm.url == "true"
        @firms_top_8_15 << deco_firm
      end
      firm_ids_top_ten_3 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[@user_city_code.to_i]]['15-30万公司TOP10'], :attributes => ['title','url'],:limit => 10)
      @firms_top_15 = []
      firm_ids_top_ten_3.each do |firm|
        deco_firm = DecoFirm.find_by_id(firm.title)
        deco_firm.is_promoted = true if firm.url == "true"
        @firms_top_15 << deco_firm
      end
    else
      ## 南京（12122）、上海（12910）、武汉（12093）按正常口碑分排序调用
      price_1 = [DecoFirm::PRICE.index("8万以下")]
      price_2 = [DecoFirm::PRICE.index("8-15万")]
      price_3 = [DecoFirm::PRICE.index("15-30万"), DecoFirm::PRICE.index("30万-100万"), DecoFirm::PRICE.index("100万以上")]

      is_promoted = @user_city_code.to_i == 11910 ? true : false
      # 8万以下
      @firms_top_8 = DecoFirm.price_top_ten(price_1, @user_city_code, is_promoted, 10)
      # 8-15万
      @firms_top_8_15 = DecoFirm.price_top_ten(price_2, @user_city_code, (@user_city_code.to_i == 12306 ? true : is_promoted), 10)
      # 15W以上
      @firms_top_15 = DecoFirm.price_top_ten(price_3, @user_city_code, is_promoted, 10)
    end

    city_conditions = (@user_city_code.to_i == 11910 || @user_city_code.to_i == 11905 || @user_city_code.to_i == 31959) ? "city=#{@user_city_code.to_i}" : "district=#{@user_city_code.to_i}"

    if @user_city_code.to_i == 12301
      #别墅TOP10
      firms_top_attention_12301 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[@user_city_code.to_i]]['别墅'], :attributes => ['title','url'],:limit => 10)
      @firms_top_attention = []
      unless firms_top_attention_12301.blank?
        deco_firm__ids = []
        @firm_tui__ids = []
        firms_top_attention_12301.each do |x|
          deco_firm__ids << x.title
          @firm_tui__ids << x.title if x.url == 'true'
        end
        @firms_top_attention = DecoFirm.find(deco_firm__ids,:select =>'id,name_abbr,praise')
        @firms_top_attention = deco_firm__ids.collect do |id|
          @firms_top_attention.detect {|firm| id.to_i == firm.id }
        end
      end

      #工装
      firms_top_rise_12301 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[@user_city_code.to_i]]['工装'], :attributes => ['title','url'],:limit => 10)
      @firms_top_rise = []
      unless firms_top_rise_12301.blank?
        deco_firm__ids = []
        @rise_tui__ids = []
        firms_top_rise_12301.each do |x|
          deco_firm__ids << x.title
          @rise_tui__ids << x.title if x.url == 'true'
        end
        @firms_top_rise = DecoFirm.find(deco_firm__ids,:select =>'id,name_abbr,praise')
        @firms_top_rise = deco_firm__ids.collect do |id|
          @firms_top_rise.detect {|firm| id.to_i == firm.id }
        end
      end
      #设计
      firms_top_remarks_12301 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[@user_city_code.to_i]]['设计'], :attributes => ['title','url'],:limit => 10)
      @firms_top_remarks = []
      unless firms_top_remarks_12301.blank?
        deco_firm__ids = []
        @remarks_tui__ids = []
        firms_top_remarks_12301.each do |x|
          deco_firm__ids << x.title
          @remarks_tui__ids << x.title if x.url == 'true'
        end
        @firms_top_remarks = DecoFirm.find(deco_firm__ids,:select =>'id,name_abbr,praise')
        @firms_top_remarks = deco_firm__ids.collect do |id|
          @firms_top_remarks.detect {|firm| id.to_i == firm.id }
        end
      end

      #宁波十大装饰公司
      firms_top_construction_praise_12301 = hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[@user_city_code.to_i]]['宁波十大装饰公司'], :attributes => ['title','url'],:limit => 10)
      @firms_top_construction_praise = []
      unless firms_top_construction_praise_12301.blank?
        deco_firm__ids = []
        @construction_praise_tui__ids = []
        firms_top_construction_praise_12301.each do |x|
          deco_firm__ids << x.title
          @construction_praise_tui__ids << x.title if x.url == 'true'
        end
        @firms_top_construction_praise = DecoFirm.find(deco_firm__ids,:select =>'id,name_abbr,praise')
        @firms_top_construction_praise = deco_firm__ids.collect do |id|
          @firms_top_construction_praise.detect {|firm| id.to_i == firm.id }
        end
      end

      #装修日记最多
      @firms_top_areas = DecoFirm.find_by_sql("select d.id, d.name_abbr, count(c.id) as c from deco_firms d,decoration_diaries c where d.district=12301 and c.deco_firm_id=d.id and c.is_verified=1 group by d.id order by d.is_cooperation desc, c desc limit 10")
    else

      #网友关注最多
      @firms_top_attention = DecoFirm.find_by_sql("select d.id, d.name_abbr, count(a.id) as c from deco_firms d,decoration_diaries c,decoration_diary_posts b,remarks a where (d.city=#{@user_city_code.to_i} or d.district=#{@user_city_code.to_i}) and c.deco_firm_id=d.id and c.is_verified = 1 and b.decoration_diary_id=c.id and a.resource_id=b.id and a.resource_type='DecorationDiaryPost' group by d.id order by d.is_cooperation desc, c desc limit 10")
      #活跃装修日记
      @firms_top_rise = DecoFirm.find_by_sql("select d.id, d.name_abbr, count(b.id) as c from deco_firms d,decoration_diaries c,decoration_diary_posts b where (d.city=#{@user_city_code.to_i} or d.district=#{@user_city_code.to_i}) and c.deco_firm_id=d.id and c.is_verified = 1 and b.decoration_diary_id=c.id and b.state=1 group by d.id order by d.is_cooperation desc, c desc limit 10")
      #一周评论最多
      @firms_top_remarks = DecoFirm.find_by_sql("select d.id, d.name_abbr, count(c.id) as c from deco_firms d,remarks c where (d.city=#{@user_city_code.to_i} or d.district=#{@user_city_code.to_i}) and c.resource_type='DecoFirm' and c.resource_id=d.id and c.created_at >'#{7.days.ago.strftime("%Y-%m-%d")}' group by d.id order by d.is_cooperation desc, c desc limit 10")
      #施工排行
      promoted_construction_ids = PromotedFirm.find_by_sql("SELECT * FROM promoted_firms where except = 0 AND district = 0 AND model = 0 AND style = 0 AND price = 0  AND order_class = 3 AND " + city_conditions)
      @firms_top_construction_praise = DecoFirm.find_by_sql("SELECT id, name_abbr, construction_praise as c FROM deco_firms where " + city_conditions + " order by is_cooperation desc, construction_praise desc limit 10")
      @promoted_construction = []
      if promoted_construction_ids.size > 0
        promoted_construction_ids[0].firms_id.each do |id|
          @promoted_construction << DecoFirm.find_by_sql("select id, name_abbr, praise as c from deco_firms where id=#{id}")
        end
        @firms_top_construction_praise.delete_if { |f| promoted_construction_ids[0].firms_id.include? f.id.to_s }
        promoted_count = promoted_construction_ids[0].firms_id.size + @firms_top_construction_praise.size
        if promoted_count != 10
          1.upto(promoted_count - 10) { @firms_top_construction_praise.pop }
        end
        @firms_top_construction_praise
      end

      #地区排行榜
      @firms_top_areas = []
      @promoted_top_areas = []
      if @user_city_code.to_i == 11910
        ["徐汇","普陀","黄浦","闵行","闸北","杨浦","长宁","嘉定","浦东"].each do |area|
          promoted_area_ids = PromotedFirm.find_by_sql("SELECT * FROM promoted_firms where city=11910 and district=#{DISTRICTS.index(area)} and price=0 and model=0 and style=0 and order_class=1")
          @firms_top_area_pv = DecoFirm.find_by_sql("SELECT id, name_abbr, pv_count as c FROM deco_firms where district=#{DISTRICTS.index(area)} order by is_cooperation desc, pv_count desc limit 10")
          @promoted_area = []
          if promoted_area_ids.size > 0
            promoted_area_ids[0].firms_id.each do |id|
              @promoted_area << DecoFirm.find_by_sql("select id, name_abbr, pv_count as c from deco_firms where id=#{id}")
            end
            @firms_top_area_pv.each_with_index do |firm, index|
              @firms_top_area_pv.delete_at(index) if promoted_area_ids[0].firms_id.include?(firm[1])
            end
          end
          @firms_top_area_pv = @firms_top_area_pv[0, 10-@promoted_area.size]
          @promoted_top_areas << @promoted_area
          @firms_top_areas << @firms_top_area_pv
        end
      elsif @user_city_code.to_i == 11905
        @firms_top_areas = DecoFirm.find_by_sql("select id, name_abbr, pv_count as c from deco_firms where (city=#{@user_city_code} or district=#{@user_city_code}) and state not in (-99, -100) order by is_cooperation desc, pv_count desc limit 10")
      elsif @user_city_code.to_i == 31959
        @firms_top_areas = DecoFirm.find_by_sql("select id, name_abbr, pv_count as c from deco_firms where (city=#{@user_city_code} or district=#{@user_city_code}) and state not in (-99, -100) order by is_cooperation desc, pv_count desc limit 10")
      else
        @firms_top_areas = DecoFirm.find_by_sql("select id, name_abbr, pv_count as c from deco_firms where (city=#{@user_city_code} or district=#{@user_city_code}) and state not in (-99, -100) order by is_cooperation desc, pv_count desc limit 10")
      end
    end
  end

  private
  def validate_top_city
    unless [11910, 12117, 12301,12122,12306,12118,12093].include?(@user_city_code.to_i)
      page_not_found!
      false
    end
  end
end