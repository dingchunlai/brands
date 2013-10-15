module BrandHelper
  extend ActiveSupport::Memoizable

  def brand_select_collection
    Brand.all(:select => 'id, name_zh').map { |brand| [brand.name_zh, brand.id] }
  end

  def get_zq_inner_link(kw, classname="", v_name=kw, only_get_url=false) #取得专区内部链接
    kw = trim(kw)
    kw_mc = "get_zq_inner_link_#{kw}"
    link = get_mc(kw_mc) do
      if kw.length == 0
        l = "http://tag.51hejia.com"
      elsif !(redirect_key_url = get_redirect_key_url(kw)).nil?
        l = redirect_key_url
      elsif !(s = ZhuanquSort.find_by_sort_name(kw,:select=>"id, board_id")).nil?
        l = "http://#{ZHUANQU_BOARD_SPELL[s.board_id.to_i]}.51hejia.com/zq/#{kw}/"
      elsif !(k =ZhuanquKw.find_by_kw_name(kw,:select=>"id,sort_id")).nil?
        s = ZhuanquSort.find(k.sort_id,:select=>"id, board_id, sort_name")
        sort_name = s.sort_name rescue "栏目"
        board_id = s.board_id
        l = "http://#{ZHUANQU_BOARD_SPELL[board_id.to_i]}.51hejia.com/zq/#{sort_name}-#{kw}.html"
      else
        l = "http://tag.51hejia.com/#{kw}.html"
      end
      l
    end

    htmlclass = ""
    htmlclass = " class='#{classname}'" if classname.to_s.length > 0
    if only_get_url
      link
    else
      "<a href='#{link}' target='_blank' #{htmlclass}>#{v_name}</a>"
    end
  end

  def mc(keyword, value=nil, expire_hours=72)  #memorycache快捷存取方法
    return nil unless defined?(CACHE)

    keyword = keyword.to_s.gsub(" ","")
    if value.nil?
      return CACHE.get(keyword)
    else
      if expire_hours == 0
        CACHE.set(keyword, value)
      else
        CACHE.set(keyword, value, expire_hours * 60 * 60)
      end
    end
  end

  def get_mc(kw_mc, expire_hours=72, update_cache=false)   #尝试获取相应关键字的memcache信息
    update_cache = false if update_cache == 0 || update_cache.nil?
    update_cache = true if update_cache == 1
    kw_mc = kw_mc.gsub(" ","")
    rv = mc(kw_mc)
    if rv.nil? || update_cache
      rv = yield
      mc(kw_mc, rv, expire_hours)
    end
    return rv
  end

  def get_redirect_key_url(name)
    (@redirect_key ||= {
      "新闻" => "http://www.51hejia.com/xinwen/",
      "行业" => "http://www.51hejia.com/xinwen/",
      "资讯" => "http://www.51hejia.com/xinwen/",
      "卖场" => "http://www.51hejia.com/maichang/",
      "博客" => "http://blog.51hejia.com/",
      "装修" => "http://d.51hejia.com/",
      "地板" => "http://www.51hejia.com/diban/",
      "涂料" => "http://www.51hejia.com/youqituliao/",
      "油漆" => "http://www.51hejia.com/youqituliao/",
      "瓷砖" => "http://www.51hejia.com/cizhuan/",
      "布艺" => "http://www.51hejia.com/buyi/",
      "家具" => "http://www.51hejia.com/jiajuchanpin/",
      "家电" => "http://www.51hejia.com/jiadian/",
      "灯具" => "http://www.51hejia.com/zhaomingpindao/",
      "灯饰" => "http://www.51hejia.com/zhaomingpindao/",
      "照明" => "http://www.51hejia.com/zhaomingpindao/",
      "采暖" => "http://www.51hejia.com/cainuan/",
      "花园" => "http://www.51hejia.com/huayuanshenghuo/",
      "装饰" => "http://www.51hejia.com/jushang/",
      "厨房" => "http://www.51hejia.com/chufang/",
      "卫浴" => "http://www.51hejia.com/weiyu/",
      "客厅" => "http://www.51hejia.com/keting/",
      "卧室" => "http://www.51hejia.com/woshi/",
      "书房" => "http://www.51hejia.com/shufang/",
      "主妇" => "http://www.51hejia.com/chaojizhufu/",
      "别墅" => "http://www.51hejia.com/bieshu/",
      "品牌" => "http://www.51hejia.com/",
      "卫生间" => "http://www.51hejia.com/weiyu/",
      "洗手间" => "http://www.51hejia.com/weiyu/",
      "儿童房" => "http://www.51hejia.com/ertongfang/",
      "小户型" => "http://www.51hejia.com/xiaohuxing/",
      "二手房" => "http://www.51hejia.com/ershoufang/",
      "水处理" => "http://www.51hejia.com/shuichuli/",
      "背景墙" => "http://www.51hejia.com/beijingqiang/",
      "时尚家居" => "http://www.51hejia.com/jushang/",
      "中央空调" => "http://www.51hejia.com/kongtiao/",
      "厨房橱柜" => "http://www.51hejia.com/chuguipindao/",
      "卫生间用品" => "http://www.51hejia.com/weiyupindao/",
      "洗手间用品" => "http://www.51hejia.com/weiyupindao/"
    })[name]
  end
  
  # 此方法纯粹多余
  def trim(str)
    str.to_s.strip
  end

  #根据品牌名得到相同品牌而不同分类的信息
  def get_same_tag_link_by_brand_name(brand_name)
    brand = ZhuanquSort.find(:first ,:conditions => ["sort_name = :sort_name",{:sort_name => brand_name}])
    if brand
      result = ZhuanquKw.find(:all, :select => "kw_name" ,:conditions => ["sort_id = :sort_id",{:sort_id => brand.id}])
    else
      result = []
    end
    return result
  end
  memoize :get_same_tag_link_by_brand_name

  # 得到某分类和品牌下的文章(先找出2张代图的)
  def get_atricle_by_category_brand_has_photo(brand_name)
    HejiaIndex.find_by_keyword brand_name, :with_image => true, :select => 'url, image_url, title', :limit => 2
  end  
  memoize :get_atricle_by_category_brand_has_photo

  # 得到某分类和品牌下的文章(先找出6张代图的)
  def get_atricle_by_category_brand_not_has_photo(brand_name)
    HejiaIndex.find_by_keyword brand_name, :with_image => false, :select => 'id, title, url', :limit => 8
  end  
  memoize :get_atricle_by_category_brand_not_has_photo

  # 得到某分类和品牌下的文章的5张文章
  def get_atricle_by_category_brand(brand_name)
      HejiaIndex.find_by_keyword brand_name, :select => 'id, title, url', :limit => 5, :entity_type_id => 1, :conditions => ["title like ?", "%#{brand_name}%"], :order => "entity_updated_at desc"
  end  
  memoize :get_atricle_by_category_brand

  # 品牌首页 文章链接地址
  def get_article_link(article)
    "http://b.51hejia.com/pinpaiku/#{article.CREATETIME.strftime('%Y%m%d') }/#{article.ID}"
  end
  memoize :get_article_link

  # 品牌首页 文章图片链接地址
  def get_article_image_link(article)
    "http://radmin.51hejia.com/files/hekea/article_img/sourceImage/#{article.IMAGENAME.slice(3,8)}/#{article.IMAGENAME}"
  end
  memoize :get_article_image_link

  # 品牌首页 品牌名称 -> 问吧页面
  def get_wb_brand_link(brand_name)
    "http://wb.51hejia.com/list/sort/0.html?wd=#{brand_name}"
  end
  memoize :get_wb_brand_link

  # 品牌首页 根据问题的编号得到对应的链接
  def get_wb_question_link(question_id)
    "http://wb.51hejia.com/q/#{question_id}.html"
  end
  memoize :get_wb_question_link

  # 品牌信息页面左侧显示品牌详细信息的链接的 TITLE URL
  def get_link_to_url(arrt,pc=nil)
    unless pc
      link_to BrandDetail::DETAIL_ATTR[arrt], pinpai_info_path(:subdomain => false, :permalink => @brand.permalink ,:item => arrt ), :class => 'close'
    else
      link_to BrandDetail::DETAIL_ATTR[arrt], second_category_info_path(:subdomain => false,:category_url =>pc, :permalink => @brand.permalink ,:item => arrt ), :class => 'close'
    end
  end
  memoize :get_link_to_url

  # 品牌的LOGO
  # @param [Brand] brand 品牌对象
  # @param [Integer] width 图片宽度
  # @param [String] class_name LOGO的样式名
  # @return [String] 带品牌logo的连接
  def get_brand_logo(brand, detail, logo, width, class_name = nil)
    url = detail.website.blank? ? show_pinpai_path(:subdomain => false, :permalink => brand.permalink, :trailing_slash => true) : detail.website
    link_to image_tag(logo.public_filename, :width => width, :alt => brand.name_zh), url, :class => class_name, :target => "_blank"
  end
  memoize :get_brand_logo
  
  # 生成连接到品牌专区的地址
  def link_to_feature(brand, text)
    ## url = LINK_URLS['品牌专区']['特殊'][@brand.name_zh] || (LINK_URLS['品牌专区']['默认'] + @brand.name_zh + '/')
    url = LINK_URLS['品牌专区']['特殊'][@brand.name_zh]
    if url.blank?
      zhuanqu_sort = ZhuanquSort.find(:first,:select=>"*",:conditions=>["sort_name = ?", @brand.name_zh])
      unless zhuanqu_sort.blank?
        url = LINK_URLS['品牌专区']['默认'] + @brand.name_zh + '/'
      end
    end

    if url.blank?
      ""
    else
      link_to text, url, :target => '_blank'
    end
  end
  memoize :link_to_feature
  
  # 编辑品牌详细信息页面
  # params[:tag] 品类对象，用于得到该品牌的所有品类的链接地址
  # params[:brand] 品牌对象，用于判断当前页面属于哪个品牌
  # params[:target] 跳转方式,生成链接的跳转方式
  # return link_to 
  def brand_detail_tag_link(tag, brand, color, target, tag_id = nil)
    color_c = color  if tag_id.to_i != 0 && tag.TAGID.to_i == tag_id.to_i
    link_to tag.TAGNAME, detail_admin_brand_path(brand, :tag_id => tag.TAGID), :target => target, :class => color_c
  end
  memoize :brand_detail_tag_link

  # 为品牌相关页面专门设计的cache机制。
  def brands_cache(options = nil, &block)
    if RAILS_ENV != 'development' && action_name == 'show' # 暂时只对品牌首页缓存
      options = {:expires_in => 30.minutes}.merge(options || {})
      cache cache_name_for_current_brand(action_name), options, &block
    else
      yield
    end
  end

end
