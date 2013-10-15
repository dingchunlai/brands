class Article < Hejia::Db::Hejia
  
  include Hejia::Promotable
  promotion_method_alias :title, :TITLE
  promotion_method_alias :description, :SUMMARY
  promotion_method_alias :content, :SUMMARY
  promotion_method_alias :url, :generate_url

  # 各种文章类型对应的CHECK_BRAND的值
  TYPES = {
    '行情' => 1,
    '导购' => 2,
    '评测' => 3,
    '热点新闻' => 4,
    '组合案例' => 5,
    '最新资讯' => 6
  }.freeze

  KEYWORDS = [
    ["地中海","dzh"],["简约","jy"],["田园","ty"],["欧式","os"],["中式","zs"],["宜家","yj"],["其它","qt"],
    ["小户型","xhx"],["公寓装修","gyzx"],["别墅装修","bszx"],["装修预算","zxys"],["装修流程","zxlc"],
    ["装修用途","zxyt"],["空间类","kjl"],["装修公司","zxgs"],["设计师","sjs"],["样板间","ybj"]
  ]

  PINLEI_SIGNS = ["youqituliao", "diban", "cizhuan", "buyi", "jiajuchanpin", "jiadian", "zhaomingpindao", "cainuan", "cainuanpindao",
    "chuguipindao", "weiyupindao", "kongtiao", "shuichuli"]
  DIANXING_SIGNS = ["chufang", "weiyu", "keting", "woshi", "shufang", "huayuanshenghuo", "beijingqiang", "ertongfang",
    "xiaohuxing", "ershoufang", "chaojizhufu", "bieshu"]
  PROMOTIONS_BY_SIGN = {'dianxing' => 54267, 'pinlei'=> 54218, 'zhuangxiu' =>54213, 'pinpaiku' => 54267, 'xinwen' => 54267, 'maichang' => 54267, 'jiaju' => 54267, 'menchuang' => 54218}

  # 与TYPES相反的一个映射
  TYPE_NAMES = TYPES.inject({}) { |h, (k, v)| h[v] = k; h }.freeze

  set_table_name "HEJIA_ARTICLE"
  set_primary_key 'ID'
  
  ## 2012-11-21日添加  资讯推广位开始
  def self.promotion_articles(limit, keyword)
    article_ids = []
=begin

=end
    tmp_article_ids = []
    zmbs = ZxMerchantBuy.find(:all, :select => "id,article_id,art_catname", :conditions => ["status=0 and art_catname like ?", "%#{keyword}%"], :order => "article_id desc")
    zmbs.each do |zmb|
      if zmb["art_catname"].split(";").include?(keyword)
        tmp_article_ids << zmb.article_id
      end
    end
    if tmp_article_ids.size <= limit
      article_ids = tmp_article_ids
    else
      limit.times do |i|
        article_id = tmp_article_ids.rand
        article_ids << article_id
        tmp_article_ids.delete(article_id)
      end
    end
    article_ids
  end
=begin
   def self.promotion(options={})
    conditions = []
    unless options[:name1].blank?
      conditions << "name1='#{options[:name1]}'"
    end
    unless options[:name2].blank?
      conditions << "name2='#{options[:name2]}'"
    end
    unless options[:name3].blank?
      conditions << "name3='#{options[:name3]}'"
    end
    ActiveRecord::Base.connection.select_all("SELECT id FROM 51hejia_php.zx_article_promotions where #{conditions.join(' and ')} order by id asc limit 1")
  end
  
  def self.promotion_articles(limit = 1, options={})
    arrays = []
    unless promotion(options).blank?
      promotion_id = promotion(options)[0]["id"]
      arrays = ActiveRecord::Base.connection.select_all("SELECT article_id FROM 51hejia_php.zx_merchant_buy where promotion_id=#{promotion_id} and status=0 order by art_view desc limit #{limit}")
    end
    arrays
  end 
=end
  ## 2012-11-21日添加  资讯推广位结束
  
  ## 油工知识
  has_many :paint_keyword_articles, :class_name => "PaintKeywordArticle"
  has_many :paint_keywords, :through => :paint_keyword_articles, :source => :paint_keyword

  # 与文章内容模型相关
  belongs_to :article_sort, :foreign_key => 'FIRSTCATEGORY'
  has_one :content, :primary_key => 'CONTENTID', :foreign_key => 'ID', :class_name => "ArticleContent"
  has_one :tag, :primary_key => 'SECONDCATEGORY', :foreign_key => 'TAGID'
  belongs_to :article_promotion_info, :primary_key => 'article_id', :foreign_key => 'ID' 
  has_many :brand_link, :primary_key => 'ID', :foreign_key => 'articleid',
    :class_name => 'HejiaArticleLink', :conditions => ["typename = 'brand' and typeid != 0"]
  # 默认只查询出来属于品牌库的文章
  default_scope :conditions => 'STATE = 0', :order => 'FIRSTORDERID DESC, CREATETIME DESC'

  #根据品类获取文章列表
  named_scope :for_tag, lambda { |tag_id|
    tag_id = tag_id.TAGID if tag_id.is_a?(Tag)
    {
      :joins => 'JOIN hejia_article_link as link ON HEJIA_ARTICLE.ID = link.articleid',
      :conditions => ["link.typename = 'brand' AND link.firstid = ?", tag_id]
    }
  }
  # 获取某个品牌下的某个品类的所有文章
  # 品牌和文章之间的关系是通过hejia_article_link表来确定的。
  named_scope :of, lambda { |category_or_its_id, brand_or_its_id|
    category_or_its_id = category_or_its_id.TAGID if category_or_its_id.is_a?(Tag)
    brand_or_its_id    = brand_or_its_id.id if brand_or_its_id.is_a?(Brand)
    {
      :joins => 'JOIN hejia_article_link as link ON HEJIA_ARTICLE.ID = link.articleid',
      :conditions => ["link.typeid = ? AND link.typename = 'brand' AND link.firstid = ?", brand_or_its_id, category_or_its_id]
    }
  }
  # 获取某个品牌下的所有文章
  named_scope :with_brand, lambda { |brand_or_its_id|
    brand_or_its_id  = brand_or_its_id.id if brand_or_its_id.is_a?(Brand)
    {
      :joins => 'JOIN hejia_article_link as link ON HEJIA_ARTICLE.ID = link.articleid',
      :conditions => ["link.typeid = ? AND link.typename = 'brand' ", brand_or_its_id]
    }
  }
  # 根据品牌类型查询文章 CHECK_BRAND
  named_scope :with_type, lambda { |type_name|{
      :conditions => ['CHECK_BRAND = ?', TYPES[type_name]]
    }
  }
  # 根据文章标题查询文章 TITLE
  named_scope :with_title, lambda { |title|{
      :conditions => ['TITLE LIKE ?', "%#{title}%"]
    }
  }
  # 热点新闻
  named_scope :hot_news, :conditions => ['CHECK_BRAND = ?', TYPES['热点新闻']]
  # 最新资讯
  named_scope :new_info, :conditions => ['CHECK_BRAND = ?', TYPES['最新资讯']]
  # 行情 + 导购 + 评测
  named_scope :all_info, :conditions => ['CHECK_BRAND in (?)', TYPES.values_at('行情', '导购', '评测')]
  # 导购 + 评测
  named_scope :pince_daogou_info, :conditions => ['CHECK_BRAND in (?)', TYPES.values_at('导购', '评测')], :order => "LASTMODIFYTIME DESC"

  named_scope :pingce, :conditions => ['CHECK_BRAND in (?)', TYPES.values_at('评测')]
  
  named_scope :duoleshi, lambda{ |youqi, limit|
    {
      :conditions => ["keyword1 like ? and keyword1 like ?", "%#{youqi}%", "%多乐士%"],
      :limit => limit
    } 
  }

  #获取关联production_categories表的文章
  named_scope :production_find,lambda {|c| {
      :joins =>'join articles_production_categories on HEJIA_ARTICLE.id=articles_production_categories.article_id',
      :conditions =>"production_category_id = #{c}"
    }}

  class << self

    ## 品牌库首页调用
    def pinpaiku_zixun_articles(limit)
      key = "pinpaiku_zixun_articles"
      rs = Hejia[:cache].fetch(key, 1.hour) do
        self.find(:all, :conditions => "FIRSTCATEGORY = 42092 and STATE <> -1", :order => "ID desc" ,:limit => limit)
      end
      rs
    end

    def category_articles(firstcategory, limit = 10)
      key = "category_#{firstcategory}_articles"
      rs = Hejia[:cache].fetch(key, 1.hour) do
        self.find(:all, :conditions => ["FIRSTCATEGORY = ? and STATE <> -1", firstcategory], :order => "ID desc", :limit => limit)
      end
      rs
    end

    #根据ID找文章
    def get_article(id)
      with_exclusive_scope { first(:conditions => ["id = ? and STATE <> -1", id], :include => :article_sort) }
    end

    # 首页推广热点评测文章
    # index_priority != 0的文章
    def hot_spot_eveluating(priority, limit, is_image = false, except_ids = nil)
      ids = if is_image 
        ArticlePromotionInfo.has_image_promotion(limit).map(&:article_id)
      else
        ArticlePromotionInfo.index_promotions(limit).map(&:article_id)
      end   
      ids = ids - except_ids.map(&:id) unless  except_ids.blank?
      find(:all, :conditions =>  ["id in (?) and CHECK_BRAND = ?", ids, TYPES['评测']],:order => "CREATETIME desc", :limit => limit)
    end
  
    # 品牌下不再首页推广的文章
    # index_priotity is null 属于无用参数
    # 主要品牌有：(油漆涂料，地板，瓷砖，吊顶，厨房电器，橱柜，卫浴洁具，中央空调，采暖，水处理，家电，家居，布艺，门窗，照明灯具)
    def of_tag(tag_names, priority, limit)
      tags = tag_names.inject([]) do |tag, name| 
        tag << BASE_CATEGORIES[name]
      end
      ids = ArticlePromotionInfo.index_promotions(limit).map(&:article_id)
      find(:all, :conditions => ["id in (?) and FIRSTCATEGORY = ? and SECONDCATEGORY in (?)", ids, BASE_CATEGORIES['品牌库'], tags], :order => "CREATETIME desc", :limit => limit)
    end
  
    #直接移过来的...
    def getarticlebytag options={}

      brand = options[:brand]
      first = options[:first]
      second = options[:second]
      third = options[:third]
      begintime = options[:begintime]
      endtime = options[:endtime]
      order = options[:order]
      beginnum = options[:beginnum]
      allnum = options[:allnum]

      conditions = []
      conditions << "STATE='0'"
      conditions << "BRAND_ID = #{brand}" if brand && brand != '0'
      conditions << "FIRSTCATEGORY = '#{first}'" if first && first != '0'
      conditions << "SECONDCATEGORY = '#{second}'" if second && second != '0'
      conditions << "THIRDCATEGORY = '#{third}'" if third && third != '0'
      conditions << "CREATETIME >= '#{begintime}'" if begintime && begintime != ''
      conditions << "CREATETIME <= '#{endtime}'" if endtime && endtime != ''

      if order == '4'
        orderstr = ' PV asc '
      elsif order == '3'
        orderstr = ' PV desc '
      elsif order == '2'
        orderstr = ' ID asc '
      elsif order == '1'
        orderstr = ' ID desc '
      elsif order == '5'
        orderstr = ' FIRSTORDERID desc,ID desc '
      elsif order == '6'
        orderstr = ' SECONDORDERID desc,ID desc '
      elsif order == '7'
        orderstr = ' THIRDORDERID desc,ID desc '
      end

      if beginnum && allnum
        articles = find(:all,
          :conditions => conditions.join(" and "),
          :order => orderstr,
          :offset => beginnum,
          :limit => allnum)

        return articles
      else
        return nil
      end
    end
  
    #多乐士文章(上一篇 /下一篇)
    #article：当前文章
    #返回上一篇文章和下一篇文章的ID
    def page_article(article)
      keywords = article.KEYWORD1
      if keywords.include?("木器漆")
        key = "木器漆"
      elsif keywords.include?("墙面漆")
        key = "墙面漆"
      else
        key = ''
      end
      articles = Article.duoleshi(key, nil).find(:all, :select => "ID")
      ids = articles.map{|a| a.ID }
      article_index = ids.index(article.ID).to_i
      if article_index == 0
        previous_article = nil
        next_article = ids[1]
      else
        previous_article = ids[article_index - 1]
        next_article = ids[article_index + 1]
      end
      [previous_article, next_article]
    end

    #油漆工知识文章(上一篇 /下一篇)
    #article：当前文章
    #返回上一篇文章和下一篇文章的ID
    def youqi_page_article(article)
      ids = PaintKeywordArticle::articles.map{|a| a.ID }
      article_index = ids.index(article.ID).to_i
      if article_index == 0
        previous_article = nil
        next_article = ids[1]
      else
        previous_article = ids[article_index - 1]
        next_article = ids[article_index + 1]
      end
      [previous_article, next_article]
    end

    def get_url_by_channel(channel_name)
      if @channels_and_urls.nil?
        channels_and_urls = "新闻 行业 资讯,http://www.51hejia.com/xinwen/;" +
          "卖场,http://www.51hejia.com/maichang/;" +
          "博客,http://blog.51hejia.com/;" +
          "装修,http://d.51hejia.com/;" +
          "地板,http://www.51hejia.com/diban/;" +
          "涂料 油漆,http://www.51hejia.com/youqituliao/;" +
          "瓷砖,http://www.51hejia.com/cizhuan/;" +
          "布艺,http://www.51hejia.com/buyi/;" +
          "家具,http://www.51hejia.com/jiajuchanpin/;" +
          "家电,http://www.51hejia.com/jiadian/;" +
          "灯具 灯饰 照明,http://www.51hejia.com/zhaomingpindao/;" +
          "采暖,http://www.51hejia.com/cainuan/;" +
          "厨房橱柜,http://www.51hejia.com/chuguipindao/;" +
          "卫浴用品 卫生间用品 洗手间用品,http://www.51hejia.com/weiyupindao/;" +
          "中央空调,http://www.51hejia.com/kongtiao/;" +
          "水处理,http://www.51hejia.com/shuichuli/;" +
          "装饰 时尚家居,http://www.51hejia.com/jushang/;" +
          "厨房,http://www.51hejia.com/chufang/;" +
          "卫浴 卫生间 洗手间,http://www.51hejia.com/weiyu/;" +
          "客厅,http://www.51hejia.com/keting/;" +
          "卧室,http://www.51hejia.com/woshi/;" +
          "书房,http://www.51hejia.com/shufang/;" +
          "花园,http://www.51hejia.com/huayuanshenghuo/;" +
          "背景墙,http://www.51hejia.com/beijingqiang/;" +
          "儿童房,http://www.51hejia.com/ertongfang/;" +
          "小户型,http://www.51hejia.com/xiaohuxing/;" +
          "二手房,http://www.51hejia.com/ershoufang/;" +
          "主妇,http://www.51hejia.com/chaojizhufu/;" +
          "别墅,http://www.51hejia.com/bieshu/;" +
          "品牌,http://b.51hejia.com/;" +
          "百安居,http://zt.51hejia.com/shanghai/baianj/index.html;"
        @channels_and_urls = channels_and_urls.split(";").inject({}) do |hash, entry|
          keys, value = entry.split ','
          keys.split(' ').each { |key| hash[key] = value }
          hash
        end
      end
      @channels_and_urls[channel_name]
    end

    def get_url_of_new_special_area(zhuanqu_sort, zhuanqu_kw, keyword)
      url = ""
      if !zhuanqu_sort.nil?
        url = "http://#{ZHUANQU_BOARD_SPELL[zhuanqu_sort.board_id.to_i]}.51hejia.com/zq/#{URI.escape(keyword)}/"
      else !zhuanqu_kw.nil?
        s = ZhuanquSort.find(zhuanqu_kw.sort_id, :select=>"id, board_id, sort_name")
        sort_name = s.sort_name rescue ""
        board_id = s.board_id
        url = "http://#{ZHUANQU_BOARD_SPELL[board_id.to_i]}.51hejia.com/zq/#{URI.escape(sort_name)}-#{URI.escape(keyword)}.html"
      end
      url
    end

    def get_url_by_keyword(keyword)
      channel_url = get_url_by_channel(keyword)
      return channel_url unless channel_url.nil?
      url = 'http://www.51hejia.com'
      zhuanqu_sort = ZhuanquSort.find(:first, :select=>"id, board_id", :conditions => ["is_delete = 0 and sort_name = ?", keyword])
      zhuanqu_kw = ZhuanquKw.find(:first, :select=>"id, sort_id", :conditions => ["is_delete = 0 and kw_name = ?", keyword])
      if zhuanqu_sort.nil? and zhuanqu_kw.nil?
        zhuanqu = ZhuanquInfo.find(:first, :conditions => ["name = ? and is_del != 0 and state = 1", keyword])
        if zhuanqu.nil?
          url = "http://tag.51hejia.com/#{URI.escape(keyword)}.html"
        else
          url = "http://www.51hejia.com/zhuanqu/#{URI.escape(keyword)}.html"
        end
      else
        url = get_url_of_new_special_area(zhuanqu_sort, zhuanqu_kw, keyword)
      end
      url
    end

    #品牌库的导购评测文章
    def daogou_pingce_articles(limit)
      max_limit = 10
      fail '参数limit不能比max_limit大' if limit > max_limit
      key = "hejia_article_daogou_pingce_articles_2_#{max_limit}"
      rs = Hejia[:cache].fetch(key, 1.hour) do
        self.find(:all,
          :select => "ID, TITLE, AUTHOR, CONTENTID, CREATETIME, FIRSTCATEGORY",
          :conditions => ["STATE = 0 and FIRSTCATEGORY = ? and CHECK_BRAND in (2, 3)", 42092],
          :order => "CREATETIME DESC", :limit => max_limit)
      end
      rs[0...limit]
    end

    def articles(limit = 10, second_category = 0, by = 'time', first_category = 0)
      max_limit = by == 'time' ? 24 : 10
      fail '参数limit不能比max_limit大' if limit > max_limit
      key = "hejia_articles_2_#{first_category}_#{second_category}_#{max_limit}_#{by}"
      rs = Hejia[:cache].fetch(key, 1.hour) do
        conditions = ["STATE = 0"]
        conditions << "FIRSTCATEGORY = #{first_category}" if first_category.to_i > 0
        conditions << "SECONDCATEGORY = #{second_category}" if second_category.to_i > 0
        #按时间取最新文章
        if by == 'time'
          order = "CREATETIME DESC"
          #按浏览量取人气最高的文章
        elsif by == 'hot'
          #这部分逻辑待定，先用 order = "CREATETIME DESC" 代替
          order = "CREATETIME DESC"
        else
          fail 'by参数值错误！'
        end
        self.find(:all,
          :select => "ID, TITLE, AUTHOR, CONTENTID, CREATETIME, FIRSTCATEGORY",
          :conditions => conditions.join(" and "),
          :order => order, :limit => max_limit)
      end
      rs[0...limit]
    end
  
  end
  
  # 文章类型名称
  def type_name
    TYPE_NAMES[self.CHECK_BRAND]
  end
  
  def id
    self.ID
  end

  def title
    self.TITLE
  end

  def generate_url
    "http://www.51hejia.com"
  end

  def created_at
    # 注意这里不能改成 self.CREATETIME 否则时间差8个小时
    read_attribute("CREATETIME")
  end

  def created_date(short_date=false)
    return '' unless created_at
    if short_date
      created_at.strftime("%m-%d")
    else
      created_at.strftime("%Y-%m-%d")
    end
  end

  def keywords
    read_attribute("KEYWORD1").to_s.gsub(',', ';').gsub(' ', ';').split(';')
  end

  def keyword_links
    keywords.map{|e| "<a href='#{Article.get_url_by_keyword(e.strip)}' target='_blank'>#{e}</a>"}.join(' ')
  end

  def self.baoming_qita_keywords(sort_id)
    key = "baoming_qita_kwywords_#{sort_id}"
    Hejia::Cache.fetch(key, 12.hours) do
      all_keywords = ZhuanquKw.find(:all, :select => "id,sort_id,kw_name", :conditions => "is_delete = 0 and sort_id = #{sort_id}").map{|zk| zk.kw_name}
      qita_keywords = all_keywords - ["现代简约婚房","简约小户型","现代简约公寓","现代简约风格装修","简约风格装修","简约设计","现代简约风格","简约风格"]
      qita_keywords = qita_keywords - ["简约田园风格装修","田园风格婚房","田园小户型","韩式田园风格装修","田园风格设计","田园风格装修","韩式田园风格"]
      qita_keywords = qita_keywords - ["欧式田园风格装修","欧式公寓","现代欧式风格","欧式风格装修","简约欧式风格","欧式古典风格","欧式田园风格"]
      qita_keywords = qita_keywords - ["明清中式风格","中式古典风格装修","中式小户型","新中式风格","中式家具","中式设计","新中式风格装修","现代中式风格装修","中式风格装修","中式古典风格","现代中式风格"]
      qita_keywords = qita_keywords - ["地中海小户型","地中海风格装修","地中海田园风格装修"]
      qita_keywords = qita_keywords - ["宜家风格装修","宜家样板房","宜家样板间","上海宜家","宜家家居"]
      qita_keywords
    end
  end

  def self.kw_name_keywords(kw_name)
    key = "kw_name_keywords_#{kw_name}"
    Hejia::Cache.fetch(key, 12.hours) do
      ZhuanquKw.find(:all, :select => "kw_name", :conditions => "is_delete = 0 and kw_name like '%#{kw_name}%'").map{|zk| zk.kw_name}
    end
  end

  def self.kw_names_keywords(kw_names)
    key = "kw_names_keywords_"
    conditions = []
    for kw_name in kw_names
      key += kw_name
      conditions << " kw_name like '%#{kw_name}%'"
    end
    conditions_str = "is_delete = 0"
    unless conditions.blank?
      conditions_str = conditions_str + " and (" + conditions.join(" or ") + ")"
    end
    Hejia::Cache.fetch(key, 12.hours) do
      ZhuanquKw.find(:all, :select => "kw_name", :conditions => conditions_str).map{|zk| zk.kw_name}
    end
  end

  ## 引导报名
  def baoming_keyword_links
    baoming_key = ""
    baoming_keywords = [
      ["jy",["现代简约婚房","简约小户型","现代简约公寓","现代简约风格装修","简约风格装修","简约设计","现代简约风格","简约风格"]],
      ["ty",["简约田园风格装修","田园风格婚房","田园小户型","韩式田园风格装修","田园风格设计","田园风格装修","韩式田园风格"]],
      ["os",["欧式田园风格装修","欧式公寓","现代欧式风格","欧式风格装修","简约欧式风格","欧式古典风格","欧式田园风格"]],
      ["zs",["明清中式风格","中式古典风格装修","中式小户型","新中式风格","中式家具","中式设计","新中式风格装修","现代中式风格装修","中式风格装修","中式古典风格","现代中式风格"]],
      ["dzh",["地中海小户型","地中海风格装修","地中海田园风格装修"]],
      ["yj",["宜家风格装修","宜家样板房","宜家样板间","上海宜家","宜家家居"]],
      ["xhx",Article.kw_name_keywords("小户型")],
      ["gyzx",["公寓式酒店","白领公寓","爱情公寓","酒店式公寓","公寓装修","单身公寓","白领公寓装修","单身公寓装修","复式阁楼","复式装修","复式装修日记","小复式","复式（越层）","复式","复式跃层"]],
      ["bszx_a",["别墅客厅", "别墅卧室","别墅厨房","重庆别墅","杭州别墅","苏州别墅","上海别墅","北京别墅","别墅风水","农村别墅","树上别墅","萨伏伊别墅","马勒别墅","流水别墅","乡村别墅","高尔夫别墅","园林别墅","度假别墅","阳光别墅","海边别墅","美国别墅","欧式别墅","中式别墅","联排别墅","园艺别墅","别墅庭院","别墅阳光房"]],
      ["bszx_b",["别墅样板间","豪华别墅","别墅效果图","别墅样板房"]],
      ["bszx_c",["别墅","别墅设计","别墅装饰","别墅装修知识","别墅庭院设计","别墅装修","美式别墅","简约别墅","混搭别墅","地中海别墅","田园别墅"]],
      ["zxys",["厨房装修预算","厨房预算","140平米装修费用","110平米装修费用","130平米装修费用","120平米装修费用","90平米装修费用","100平米装修费用","80平米装修费用","70平米装修费用","60平米装修费用","50平米装修费用","40平米装修费用"]],
      ["zxlc",["垭口装修","墙面翻新","墙面裂缝","开荒保洁","地板保养","地板铺设","木地板安装","安装门窗","封阳台","墙纸基膜","安装门锁","卫生间防水","地面找平","地暖施工","墙体彩绘","水电验收","水电改造","装修拆墙"]],
      ["zxyt",["老房改造","二手房改造","老房翻新装修","二手房装修","二手房改造费用"]],
      ["kjl",Article.kw_names_keywords(["含客厅","厨房","卧室","卫生间","阳台","阳光房","餐厅","阁楼","飘窗","吧台关键词"])],
      ["zxgs",Article.kw_name_keywords("装修公司")],
      ["sjs",["十上","真水无香","瀚高融空间","木水","陈禹","非空","鬼手帕"]],
      ["ybj",["瑞丽家居样板间","美好家园样板间","时尚家居样板间","精装修样板间","装修样板房","样板房设计"]],
      ["qt",Article.baoming_qita_keywords(169)]
    ]
    for baoming_keyword in baoming_keywords
      for e in keywords
        if baoming_keyword[1].include?(e)
          baoming_key = baoming_keyword[0]
          break;
        end
      end
      unless baoming_key.blank?
        break;
      end
    end
    baoming_key
  end

  def style_id
    case keywords.join(';')
    when /现代|简约|日式|韩式|乐活|北欧|波普|ArtDeco|雅致|黑白|宜家|时尚|极简|可爱|温馨|浪漫|清风|梦幻|实用|典雅/ then 1
    when /田园|乡村|古典/ then 2
    when /欧式|美式|复古|怀旧|法式|英式|普罗旺斯|新古典|英伦|自然|托斯卡纳|意大利|简欧|宫廷|罗马|西班牙|传统|经典|加州/ then 3
    when /中式|禅意|藏式|园林|明清/ then 4
    when /地中海|希腊|爱琴海/ then 5
    when /混搭|东南亚|波西米亚|个性|另类/ then 6
    else 0
    end
  end

  #转载声明
  def statement
    read_attribute("SOURCE").to_s.strip == "原创[带版权]" ? "转载声明：此文系和家网原创稿件，如需转载，请注明出处（和家网）及作者，违者本网将追究责任！<br /><br />" : ''
  end

  def next_article
    memkey = "memkey_next_article_#{self.ID}"
    Hejia::Cache.fetch(memkey, 2.days) do
      article = Article.first(:select => "ID, TITLE, AUTHOR, CONTENTID, CREATETIME, FIRSTCATEGORY",
        :conditions => ["ID < ? and FIRSTORDERID <> -1 and STATE = 0 and FIRSTCATEGORY = ?", self.ID, self.FIRSTCATEGORY],
        :order => "ID desc")
      article && "<a title=\"下一篇文章\" href=\"#{article.detail_url}\">#{article.title}</a>" || '无'
    end
  end

  # 文章终端页url
  def detail_url(is_preview = false, page = 1)
    page_str = ''
    page_str = '-all' if page == 'all'
    page_str = "-#{page}" if page.to_i > 1
    date = created_at && created_at.strftime('%Y%m%d') || '20000101'
    "http://#{subdomain}.51hejia.com/#{sort_sign}/#{date}/#{id}#{is_preview && '_preview' || ''}#{page_str}"
  end
  
  # 文章默认图片地址
  def detail_img_url
    image_url = "http://www.51hejia.com/api/images/none.gif"
    image_name = self.IMAGENAME
    create_time = self.CREATETIME.strftime("%Y%m%d") rescue ""
    unless image_name.nil?
      if image_name.include?("img")
        image_url = "http://img.51hejia.com/files/hekea/article_img/sourceImage/#{image_name[3..10]}/#{image_name} "
      else
        image_url = "http://img.51hejia.com/files/hekea/article_img/sourceImage/#{create_time}/#{image_name} "
      end
    end
    return image_url
=begin
    if self.IMAGENAME
      img = 'http://img.51hejia.com/files/hekea/article_img/sourceImage/'+self.IMAGENAME.slice(3,8)+'/'+self.IMAGENAME
    else
      img = 'http://img3.51hejia.com/api/images/none.gif'
    end 
=end
  end
  
  def sort_name
    self.article_sort && self.article_sort.name || '未知文章分类'
  end
  
  def sort_sign
    self.article_sort && self.article_sort.sign || ''
  end
  
  def template_name
    self.article_sort && self.article_sort.template_name || 'common'
  end
  
  def subdomain
    self.article_sort && self.article_sort.subdomain || 'www'
  end

  def channel_sign
    channel = sort_sign
    channel = 'pinlei' if PINLEI_SIGNS.include?(sort_sign)
    channel = 'dianxing' if DIANXING_SIGNS.include?(sort_sign)
    channel
  end
  
  #生成HTML头部过期时间
  def headers_expire
    created_at = read_attribute("CREATETIME")
    created_at = Time.local(2010,1,1,12,30,0) if created_at.nil?
    now = Time.now
    expire = Time.local(now.year,now.month,now.day,created_at.hour,created_at.min,created_at.sec)
    expire = expire + 12.hours if expire <= now
    expire.httpdate
  end

  def seo_title
    title_string = title
    title_string += "_#{sort_name}"
    second_tag = Tag.get_tagname(Article.get_article(self.ID).SECONDCATEGORY)
    title_string += "_#{second_tag}" if second_tag
    title_string += "_和家装修家居网"
  end

  def seo_keywords
    (keywords + [title]).join(';')
  end

  def seo_description
    self.SUMMARY.blank? ? title : self.SUMMARY.gsub("\"", "'")
  end

  def route_sign(is_preview = false)
    # first_tag = Tag.get_tagname(self.FIRSTCATEGORY)
    second_tag = Tag.get_tagname(self.SECONDCATEGORY)
    rs = ["<a target=\"_blank\" href=\"http://www.51hejia.com\">和家网</a>"]
    if subdomain == 'd' || subdomain == 'b'
      rs << "<a target=\"_blank\" href=\"http://#{subdomain}.51hejia.com\">#{sort_name}</a>"
    else
      rs << "<a target=\"_blank\" href=\"http://#{subdomain}.51hejia.com/#{sort_sign}/\">#{sort_name}</a>"
    end
    rs << "<a target=\"_blank\" href=\"http://www.51hejia.com/articleList/s-#{self.SECONDCATEGORY}\">#{second_tag}</a>" if second_tag
    rs << "&nbsp;&nbsp;&nbsp;资讯正文#{is_preview ? "　<b style='color:red'>[预览状态]</b>" : ""}"
    rs.join(' > ')
  end

  ## 文章最新更新
  def newest_articles(limit = 8)
    key = "Article_#{self.article_sort.id}_newest_articles"
    tmp_articles = Hejia[:cache].fetch(key, 12.hours) do
      Article.find_by_sql("SELECT * FROM `HEJIA_ARTICLE` WHERE (`HEJIA_ARTICLE`.FIRSTCATEGORY = #{self.article_sort.id} AND (STATE = 0) AND (THIRDORDERID = 0 and SECONDORDERID = 0 and FIRSTORDERID = 0)) ORDER BY id desc, FIRSTORDERID DESC, CREATETIME DESC LIMIT #{limit}")
    end
    tmp_articles
=begin
    key = "Article_#{self.ID}_newest_articles"
    Hejia::Cache.fetch(key, 12.hours) do
      Article.find_by_sql("SELECT * FROM `HEJIA_ARTICLE` WHERE (`HEJIA_ARTICLE`.FIRSTCATEGORY = #{self.article_sort.id} AND (STATE = 0) AND (THIRDORDERID = 0 and SECONDORDERID = 0 and FIRSTORDERID = 0)) ORDER BY id desc, FIRSTORDERID DESC, CREATETIME DESC LIMIT #{limit}")
    end
=end
  end

end
