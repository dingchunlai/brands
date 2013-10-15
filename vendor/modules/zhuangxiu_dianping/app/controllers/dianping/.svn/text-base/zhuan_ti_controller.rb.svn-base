class Dianping::ZhuanTiController < Dianping::ApplicationController
  helper 'dianping/application'

  before_filter :validate_city,:except =>:super_man_game
  before_filter :get_all_data,:except =>:super_man_game

  #layout false,:except =>[:super_man_game,:fitment]

  def super_man_game
    @title = "达人争霸赛"
    #@shanghai_diaries_top_10 = DecorationDiary.daren(true).verified_is(1)
    @except_shanghai_diaries_top_10 = DecorationDiary.daren(false).verified_is(1)
    @prizes = hejia_promotion_items(54073, :attributes => ['title'],:limit => 10)
    @promotion_diary = hejia_promotion_items(55029, :attributes => ['title','url','image_url','description'], :limit => 10)
    expires_in 5.minutes, :public => true
  end


  def fitment
  end

  def arranged
    @arranged_api = get_api_tuiguan(55345)
    render :layout =>false
  end

  def waterandelectricity
    @waterandelectricity_api = get_api_tuiguan(55346)
    render :layout =>false
  end

  def earthwork
    @earthwork_api = get_api_tuiguan(55347)
    render :layout =>false
  end

  def paint
    @paint_api = get_api_tuiguan(55348)
    render :layout =>false
  end

  def ending
    @ending_api = get_api_tuiguan(55349)
    render :layout =>false
  end

  def furniture
    @furniture_api = get_api_tuiguan(55350)
    render :layout =>false
  end


  private

  def validate_city
    unless @user_city_code.to_i == 11910
      page_not_found!
      return false
    end
  end

  def get_all_data
    price_1 = [DecoFirm::NINBO_PRICE.index("6万以下")]
    price_2 = [DecoFirm::NINBO_PRICE.index("6-10万")]
    @hot_stories = DecorationDiary.published.city_num_for(11910)
    #8万以下
    @firms_top_8 = DecoFirm.price_top_ten(price_1, 11910, true, 10)
    #8-15万
    @firms_top_8_15 = DecoFirm.price_top_ten(price_2, 11910, true, 10)
    @firms_top_attention = DecoFirm.find_by_sql("select d.id, d.name_abbr, count(b.id) as c from deco_firms d,decoration_diaries c,decoration_diary_posts b where d.city=11910 and c.deco_firm_id=d.id and c.is_verified = 1 and b.decoration_diary_id=c.id and b.state=1 group by d.id order by d.is_cooperation desc, c desc limit 10")
  end

  def get_api_tuiguan(id)
    hejia_promotion_items(id,:select =>'id,title,url,image_url')
  end

end