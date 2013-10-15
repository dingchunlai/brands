class Zhuangxiuzixun::HomeController < Zhuangxiuzixun::ApplicationController
  include IpHelper
  caches_action :index, :expires_in => 5.minutes

  def index
    city = remote_city
    city_code = city[:number].to_i
    #@cases = hejia_promotion_items(ZHUANGXIUZIXUN_INDEX_PROMOTED[TAGURLS[city_code]]["首页案例"], :attributes => ["title","url"], :limit => 4)
    @new_cases = hejia_promotion_items(55307, :attributes => ["title","url","image_url","price_ago","price_now"], :limit => 4)
    @home_diaries = []
    if TAGURLS[city_code] and ZHUANGXIUZIXUN_INDEX_PROMOTED[TAGURLS[city_code]]
      @home_diaries = hejia_promotion_items(ZHUANGXIUZIXUN_INDEX_PROMOTED[TAGURLS[city_code]]["首页装修日记"], :attributes => ["title","url"], :limit => 5)
    end
  end
  
  #d.51hejia.com的缓存地址
  def d_index_cache_path
    city = remote_city
    city_code = city[:number]
    "d/index/home/cache/#{city_code}"
  end
end