class Dianping::ThemeController < Dianping::ApplicationController
  
  before_filter :validate_theme_city,  :only => [:index]  #验证是否为宁波或是无锡
 
  def index
    #专题,专访
    # promoted_id = [ZHUANGXIU_DIANPING_INDEX_PROMOTED[@city_name]['专题'],ZHUANGXIU_DIANPING_INDEX_PROMOTED[@city_name]['专访']]
    zx_api = NEW_DIANPING_HOME_API[TAGURLS[@user_city_code.to_i]]['资讯']
    zt_api = NEW_DIANPING_HOME_API[TAGURLS[@user_city_code.to_i]]['专题']
    tzh_api = NEW_DIANPING_HOME_API[TAGURLS[@user_city_code.to_i]]['装修公司谈装潢']
    #promoted_id = [ZHUANGXIU_DIANPING_INDEX_PROMOTED[@city_name]['本地资讯']]
    @themes_zx = PublishContent.search_theme(zx_api)
    @themes_zt = PublishContent.search_theme(zt_api)
    @themes_tzh = PublishContent.search_theme(tzh_api)
    all_themes = (@themes_zx + @themes_zt + @themes_tzh).sort_by {|t| t.created_at }.reverse
    @themes = all_themes.paginate :page => params[:page], :per_page => 26
    expires_in 5.minutes, :public => true
  end

  #和家专访
  def interview
    api_id = NEW_DIANPING_HOME_API[TAGURLS[@user_city_code.to_i]]['和家专访']
    @interviews = PublishContent.search_theme(api_id).paginate :page => params[:page], :per_page => 26
    expires_in 5.minutes, :public => true
  end
  
  private
  def validate_theme_city
    @city_name = TAGURLS[@user_city_code.to_i]
  end
end
