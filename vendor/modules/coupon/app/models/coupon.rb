# 关于排序由于有priority = NULL的值 ，于是此处排序是按照DESC进行
# add_column sort 用于人气排名  前台打印下载都给改值加1
#require_dependency '../lib/coupon_serialize'
class Coupon < ActiveRecord::Base

  include HejiaCouponSerializable
  hejia_set_serialization []

  @@priority_value = 2
  ORDER_TYPES = ['默认排序', '最新发布', '下载次数', '截止时间', '浏览次数', '优惠比例']
  STATUS = {0 => '待审核', 1 => '正常', 2 => '遭投诉', 3 => '暂停', 4 => '图生成中', 5 => '已过期'}
  CITIES = {1 => '上海', 2 => '南京', 132 => '苏州', 223 => '杭州', 131 => '无锡', 214 => '宁波', 7 => '合肥', 167 => '青岛' }

  has_many :complaints
  has_many :coupon_downloads

  #不采用 has_many coupon_downloads do; def; with_confirmed;xxx;end;end 添加这个避免数据统计多次查询
  has_many :coupon_confirmed_downloads, :foreign_key => :coupon_id, :class_name => 'CouponDownload', :conditions => ["is_confirm = ?", '1']

  has_many :coupon_recommendations
  has_many :coupon_remarks, :as => :resource, :include => :user
  has_many :coupon_commissions
  # 有关联关系表
  has_and_belongs_to_many :production_categories, :order => "priority desc"

  belongs_to :distributor_shop, :foreign_key => :shop_id, :class_name => 'Distributor::Shop'
  belongs_to :distributor, :counter_cache => true
  belongs_to :tag, :class_name => 'Industry', :foreign_key => :tag_id
  belongs_to :brand

  acts_as_list :column => "priority", :manual => true

  validates_presence_of :title, :activity_began_at, :activity_end_at, :discount_amount, :return_amount
  validates_format_of :distributor_id, :contract_id, :shop_id, :tag_id, :brand_id, :with => /^[1-9]\d*$/
  #校验抵用券金额
  validates_format_of :discount_amount, :return_amount, :total_issue_number, :virtual_existing_number, :with => /^[1-9]\d*$/
  # => validates_format_of :total_issue_number, :existing_number, :with => /^[1-9]\d*$/
  # 验证
  validates_format_of :commission, :with => /^[1-9]\d*$/, :if => Proc.new { |coupon| coupon.commission.to_i != 0 }

  # 添加检测品牌行业合成名方法 update_brand_industry_name
  before_update :update_sort_value, :update_brand_industry_name
  after_create :create_print_properties


  def serialization_key
    shop = self.distributor_shop
    city = City.find(shop.city_id)
    "hejia:coupon:city_#{city.code_name}:tag_#{self.tag.code}"
  end
  
  after_create do |record|
    # ( UPCASE! )城市 + 行业 + 品类 + (城市_行业_抵用券数量 - 位数: 3)
    production_categories = record.production_categories
    shop = record.distributor_shop
    city = City.find(shop.city_id)
    codes_count = record.next_success
    record.code = "#{city.code_name}#{record.tag.code}#{production_categories.length > 1 ? '0' : production_categories[0].code}#{codes_count.to_s.rjust(3, '0')}".upcase

    address = ''
    if shop.market_shop_id.nil?
      address = shop.address
    else
      market_shop = MarketShop.find(shop.market_shop_id)
      market = market_shop.market
      address = "#{market.name}(#{shop.address})"
    end

    record.sms_msg = "#{record.brand.name_zh}#{record.tag.TAGNAME}现金券"\
                  "#{record.return_amount}元(满#{record.discount_amount}元使用),地址:"\
                  "#{address},#{record.activity_began_at('%m.%d')}-#{record.activity_end_at('%m.%d')}有效,客服400-602-5151【和家网】"

    record.brand_industry_name = (record.brand.name_zh + record.tag.short_name) if record.brand_industry_name.blank? # 如果未输入名称则此处合成
    record.existing_number = record.total_issue_number

    # 预防录入错误: 小于5张 调整为 10张
    record.total_issue_number = 10 if record.total_issue_number.to_i <= 5
    
    if record.total_issue_number.to_i >= 50
      record.virtual_existing_number = record.total_issue_number - (5 + rand(6))
    else
      record.virtual_existing_number = record.total_issue_number - (1 + rand(5))
    end
    record.difference_value = record.total_issue_number - record.virtual_existing_number

    record.status = 0 #record.sms_msg.mb_chars.length > 70 ? 0 : 1
    record.save
  end

  def before_validation
    production_categories = self.production_categories
    self.city_id = self.distributor_shop && self.distributor_shop.city_id || 0
    self.discount_rate = (10000.0 * return_amount / discount_amount).round
    self.title = "购#{self.brand.name_zh}#{production_categories.map{|pc| pc.name}.join}满#{self.discount_amount}元抵现金#{self.return_amount}元" if self.title.to_s.blank?
    self.seo_title = self.title
  end

  default_scope :conditions => "coupons.deleted = 0"

  named_scope :by_city, lambda { |city|
    { :conditions => ['city_id = ?', city] }
  }

  named_scope :with_status, lambda { |status|
    { :conditions => ['status = ?', status] }
  }


  named_scope :like_code, lambda { |str|
    { :conditions => str.blank? ? nil : ["code like ?", "%#{str}%"] }
  }

  named_scope :with_contracts, lambda { |contracts|
    {
        :conditions => ["contract_id in (?)", contracts]
    }
  }

  named_scope :order_down, :order => 'downloads_count DESC'
      
  # 添加条件|已发布的|
  named_scope :valid_status, :conditions => "coupons.status = 1"
  
  named_scope :valid, :conditions => ["coupons.status = 1 and coupons.activity_began_at <= ? and coupons.activity_end_at >= ?", Time.zone.today, Time.zone.today]

  # 提取失效日期为今天的抵用卷
  # 每天早上00：01分开始跑
  named_scope :period_as_today_and_valid, :conditions => ["coupons.status = 1 and coupons.activity_end_at = ?", 1.day.ago.to_date]

  named_scope :by_distributor_ids, lambda { |distributor_ids|
    { :conditions => ["distributor_id in (?)", distributor_ids] }
  }

  named_scope :by_validity_time, lambda { |validity_time|
    { :conditions => ["activity_end_at >= ? or activity_began_at <= ?", validity_time.ago, validity_time.from_now] }
  }

  named_scope :by_tag_id, lambda { |tag_id|
    { :conditions => (tag_id.to_i == 0 ? nil : ["tag_id = ?", tag_id]) }
  }

  named_scope :by_production_category_id, lambda { |production_category_id|
    coupon_ids = CouponsProductionCategory.all(:select => 'coupon_id', :conditions => ['production_category_id = ?', production_category_id]).map{|c| c.coupon_id}
    { :conditions => ["id in (?)", coupon_ids.length > 0 ? coupon_ids : 0] }
  }

  named_scope :by_brand_id, lambda { |brand_id|
    { :conditions => ["brand_id = ?", brand_id] }
  }

  named_scope :by_shops, lambda { |shops|
    (shops.class==Array && shops.length > 0) ? { :conditions => ["shop_id in (?)", shops] } : { :conditions => ["shop_id = 0"] }
  }

  named_scope :by_shop, lambda { |shop|
    { :conditions => ["shop_id = ?", shop] }
  }

  named_scope :by_ids, lambda { |ids|
    ids = [] if ids.nil?
    ids = ids.to_s.split(',') unless ids.is_a?(Array)
    {:conditions => ["id in (?)", ids.length == 0 ? 0 : ids] }
  }
  
  # 根据抵用卷标题进行查询
  named_scope :with_title, lambda { |title| {
      :conditions => (title.blank? ? nil : ['title like ?', "%#{title}%"])
    }
  }

  # 根据抵用卷标题进行查询
  # params[:order] 为前台选择的是标题还是CODE
  named_scope :with_title_code, lambda { |order, title| 
    name = (order == 0 ? 'title' : 'code')
    {
      :conditions => (title.blank? ? nil : ["#{name} LIKE ?", "%#{title}%"])
    }
  }

  # 根据城市下，某行业的抵用卷
  # 根据人气值　sort排序
  named_scope :with_tag_city, lambda { |tag_id, city, limit| 
    {
      :select => 'coupons.*',
      :joins  => 'JOIN distributor_shops on distributor_shops.id = coupons.shop_id',
      :conditions => ['coupons.status = ? and coupons.tag_id = ? and distributor_shops.city_id = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ?', 1, tag_id, city, Time.zone.today, Time.zone.today],
      :limit => limit, 
      :order => "coupons.commission desc, coupons.sort DESC"
    }
  }
  
  # 根据城市编号取得最新的优惠券
  # 根据　开始时间排序
  named_scope :with_city_new, lambda {|city, limit|
    city = (city.kind_of?(City) ? city.id : city)
    {
      :select => 'coupons.*',
      :joins  => 'JOIN distributor_shops on distributor_shops.id = coupons.shop_id',
      :conditions => ['coupons.status = ? and distributor_shops.city_id = ? and coupons.activity_began_at <= ? and coupons.activity_end_at >= ?', 1, city, Time.zone.today, Time.zone.today],
      :limit => limit,
      :order => "coupons.activity_began_at DESC"
    }
  }

  # 根据城市来查询抵用卷信息
  named_scope :with_city, lambda {|city|
   {
     :conditions => ((city.blank? || city.to_i == 0) ? nil : ["city_id = ?", city.to_i])
   }
  }
  # 查询在有效期内
  # 按照权重值排序 查询条数
  # options[:order] [:limit]
  named_scope :with_period, lambda { |options|
    order = options.try(:[], :order) || 'DESC'
    limit = options.try(:[], :limit) || nil 
    {
      :conditions => ["activity_began_at <= ? and activity_end_at >= ? and status = ?", Time.zone.today, Time.zone.today, 1],
      :order => "priority #{order}",
      :limit => limit 
    }
  }

  # 取得现有排序中的最大值
  # 也就是排名为第1位
  named_scope :max_priority, :conditions => "priority is not null", :limit => 1

  # 查询有无设置权重值的数据
  # 1为未设置权重值
  # 2为设置国权重值
  named_scope :with_priority, lambda { |pri| 
    {
      :conditions => (pri == 1 ? "priority is not null" : (pri == 2  ? "priority is null" : nil))
    }
  }
  
  class << self

    # 本周人气  key_
    # options[:week] 表示几周前
    def sort_key(options = nil)
      year = Time.now.strftime('%Y')
      week = Time.now.strftime("%U")
      if options && options[:tag_id]
        tag_id = options[:tag_id].to_i
        city_code = options[:city_code]
        unless options && options[:week].blank?
          num = options[:week].to_i * 7
          year = num.day.ago.year
          week = num.day.ago.strftime('%U')
        end
      end
      "coupons:#{city_code}:#{tag_id}:#{year}:#{week}:sort"
    end
  
    # 取得上周某个行业的排名
    # 请注意city_code(shanghai) 而非city_id
    def last_week_rank_of(tag_id, city_code, limit)
      city_code = (city_code.kind_of?(City) ? city_code.pinyin : city_code)
      ids = $redis.zrevrange(
        sort_key({:tag_id => tag_id, :city_code => city_code, :week => 1}),
        0, limit - 1
      ).map!(&:to_i)

      coupons = find ids

      ids.map! {|id| coupons.detect {|b| b.id == id.to_i } }
    end

 
    # 设置｜｜获取默认的使用说明
    def default_usage(value = nil)
      $redis.set(default_usage_key, value) unless value.blank?
      $redis.get default_usage_key
    end

    def on_line_display_amount(value = nil)
      $redis.set(on_line_display_amount_key, value) unless value.blank?
      $redis.get(on_line_display_amount_key).to_i
    end

    # 默认说明默认key
    def default_usage_key
      "coupon:default_usage"
    end
    private :default_usage_key

    def on_line_display_amount_key
      "coupon:on_line_display_amount"
    end
    private :on_line_display_amount_key

    # 取得现有指定排序的数量
    def promotion_count
      count(:conditions => "priority is not null")
    end

    # 根据前台输入的数量，查询出来对应的抵用卷数量
    def priority_item(count)
      find(:all, :select => 'priority', :conditions => "priority is not null", :order => 'priority DESC', :limit => (count.to_i + 5))
    end

    # 转换前台所输入的排名数 如：10
    # 判断查询出来抵用卷数据信息 
    def ranked(count)
      # 外部传入进来参数
      pri = count.to_i
      # 取得对应的数量
      object = priority_item(count)
      priority_count = object && object.size || 0
      # 当0记录时
      if priority_count.to_i == 0 || count.to_i == 0 
        pri = 1
      else
        if priority_count.to_i >= count.to_i 
          pri = object[count.to_i - 1].priority + 1
        else
          pri = 1
        end
      end
      pri
    end

    # 取得有效抵用卷的数量
    def valid_count(city_id = nil, distributor_ids = nil)
      unless distributor_ids.blank?
        if distributor_ids.is_a?(Array) 
          Coupon.count('id', :conditions => ["activity_began_at <= ? and  activity_end_at >= ? and status = 1 and id in (?)", Time.zone.today, Time.zone.today, distributor_ids])
        end
      else
        Rails.cache.fetch("coupon_valid_count_#{city_id}", 1.hour) do
          unless city_id.blank?
            Coupon.count('id', :conditions => ["activity_began_at <= ? and  activity_end_at >= ? and city_id = ? and status = 1", Time.zone.today, Time.zone.today, city_id])
          else
            Coupon.count('id', :conditions => ["activity_began_at <= ? and  activity_end_at >= ? and status = 1", Time.zone.today, Time.zone.today])
          end
        end
      end
    end

    def exact_count(city_id = nil)
      count = 12785 
      Rails.cache.fetch("coupon_exact_count_#{city_id}", 1.hour) do
        unless city_id.blank?
          count += Coupon.sum("downloads_count + prints_count", :conditions => ["activity_began_at <= ? and  activity_end_at >= ? and city_id = ? and status = 1", Time.zone.today, Time.zone.today, city_id]).to_i
        else
          count += Coupon.sum("downloads_count + prints_count", :conditions => ["activity_began_at <= ? and  activity_end_at >= ? and status = 1", Time.zone.today, Time.zone.today]).to_i
        end
      end
      count
    end

    def for_brand_downloads_count(brand_id, city_id)
      Coupon.count_by_sql("select sum(downloads_count) + sum(difference_value) as sum_count from coupons where brand_id = #{brand_id} and city_id = #{city_id} and activity_began_at <= '#{Time.zone.today}' and activity_end_at >= '#{Time.zone.today}' and status = 1")
    end

    #最优惠的抵用券
    def most_discounted(city, limit=6)
      Coupon.valid.by_city(city).all(:limit => limit, :order => 'discount_rate desc')
    end

    def get_search_options(tag_id, pc_id, brand_id)
      #以下是为三种options的scope赋初始值
      tag_options = tag_id!=0 ? nil : Tag
      pc_options = pc_id!=0 ? nil : ProductionCategory
      if brand_id!=0
        brand_options = nil
      else
        brand_options = pc_id==0 ? Brand : ProductionCategory.find(pc_id).brands
      end
      #以下是判断在各种情况下进一步限定三种options的scope范围
      if tag_id != 0
        pc_options = pc_options && pc_options.for_tag(tag_id)
        brand_options = brand_options && brand_options.of_tag(tag_id, true)
      end
      if pc_id != 0
        tag_options = tag_options && tag_options.for_production_category_id(pc_id)
      end
      if brand_id != 0
        tag_options = tag_options && tag_options.for_brand(brand_id)
        pc_options = pc_options && pc_options.for_brand(brand_id)
      end
      tag_options = tag_options && (tag_options==Tag ? tag_options.all_categories : tag_options.all)

      #当行业的候选项只有一项的时候，直接把候选项设为“选中的行业”并清空候选项数组
      if tag_options && tag_options.length == 1
        tag_id = tag_options[0].TAGID
        tag_options = nil
      end
      #当“产品”有被选择，且被选择项不在候选项数组中的时候，清除“产品”选择焦点
      if pc_id != 0 && (tag_id !=0 || brand_id !=0) && pc_options
        pc_id = 0 unless pc_options.map{|pc| pc.id}.include?(pc_id)
      end
      #当“品牌”与被选择，且被选择项不在候选项数组中的时候，清除“品牌”选择焦点
      if brand_id != 0 && (tag_id !=0 || pc_id !=0) && brand_options
        brand_id = 0 unless brand_options.map{|b| b.id}.include?(brand_id)
      end

      if pc_options == ProductionCategory
        pc_options = PromotionCollection.published_items_for('品牌库:抵用券:首页:品类搜索项').map{|p| [p.title, p.url]}
      else
        pc_options = pc_options && pc_options.all.map{ |pc| [pc.name, pc.id]}
      end

      if brand_options == Brand
        brand_options = PromotionCollection.published_items_for('品牌库:抵用券:首页:品牌搜索项').map{|p| [p.title, p.url]}
      else
        brand_options = brand_options && brand_options.all.map{|b| [b.name_zh, b.id]}
      end

      return tag_id, pc_id, brand_id,
        tag_options && tag_options.map{ |t| [t.TAGNAME, t.TAGID] },
        pc_options,
        brand_options
    end

    def get_area_search_options(district_id, bz_id, shop_id, city_id)
      district_options = bz_options = shop_options = market_options = nil
      if district_id==0 && bz_id==0 && shop_id==0
        district_options = City.find(city_id).districts
        bz_options = BusinessZone.by_city(city_id)
        shop_options = MarketShop.find(:all, :conditions => ['city_id in (?)', city_id])
        market_options = shop_options.group_by{|shop| shop.market_id}
      elsif shop_id != 0
        shop = MarketShop.record_by_id(shop_id)
        bz_id = shop.business_zone_id.to_i
        district_id = shop.district_id
      elsif bz_id != 0
        bz = BusinessZone.find(bz_id)
        district_id = bz.district_id
        shop_options = bz.market_shops
      elsif district_id != 0
        district = District.record_by_id(district_id)
        bz_options = district.business_zones
        shop_options = MarketShop.find(:all, :conditions => ['district_id = ?', district_id])
      end

      return district_id, bz_id, shop_id,
        district_options && district_options.map{|d| [d.name, d.id]},
        bz_options && bz_options.map{|m| [m.name, m.id]},
        shop_options && shop_options.map{|s| [s.name, s.id]},
        market_options
    end

  end

  def url
    "/coupon/show?id=#{id}"
  end

  def status_explain
    STATUS[status]
  end

  def activity_began_at(format='%Y-%m-%d')
    read_attribute('activity_began_at') && read_attribute('activity_began_at').strftime(format) || ''
  end

  def activity_end_at(format='%Y-%m-%d')
    read_attribute('activity_end_at') && read_attribute('activity_end_at').strftime(format) || ''
  end

  def distributor_short_title(limit=0)
    limit > 0 ? self.distributor.short_title.to_s.mb_chars[0..(limit-1)] : self.distributor.short_title
  end

  def distributor_shop_address
    self.distributor_shop.address
  end

  def category_options
    if tag_id.to_i==0 || brand_id.to_i==0
      options = []
    else
      options = ProductionCategory.for_tag(tag_id).for_brand(brand_id).map{ |pc| [pc.name, pc.id]}
    end
    options
  end

  # 获取当前真实排名
  def coupon_score
    priority ? (score(priority) + 1) : '---'
  end

  # 取的当前排名 辅助方法
  def score(pri)
    Coupon.count_by_sql("select count(*) from coupons where priority > #{pri}")
  end
  private :score
 
  # 生成存贮pv|download|print的key值 
  def genration_key(key)
    if key == "download"
      "coupons:#{id}:download"
    elsif key == "print"
      "coupons:#{id}:print"
    else
      "coupons:#{id}:pv"
    end
  end
  private :genration_key

  # 生成存贮pv|download|print的对应的字段
  def genration_field(key)
    case key
    when 'download'
      'downloads_count'
    when 'print'
      'prints_count'
    else
      'pv'
    end
  end
  private :genration_field
 
  # 读取总数 || 或者某一天的数据信息
  # :key  => "download || print || pv"  标识为下载|打印|浏览
  # :when => "Time对象 || nil"    标识某天的记录数(没有此参数则表示)全部数值
  # return count
  def count(options = nil)
    key = genration_key(options.try(:[], :key) || "pv")
    if options[:when].blank?
      time = (options.try(:[], :when) || Time.now).strftime "%Y%m%d"
      $redis.hget(key, time).to_i
    else
      #$redis.hget(key, "total").to_i + 1
      case key
      when 'download'
        self.downloads_count
      when 'print'
        self.prints_count
      else
        self.pv
      end
    end
  end


  # 添加数据信息
  # :key  => "download || print || pv"  标识为下载|打印|浏览
  # :when => "20100912 || nil"    标识某天的记录数(没有此参数则表示)全部数值
  # :n => number || nil           标识添加记录数的量|无则自加1
  def increase_count!(options = nil)
    time = (options.try(:[], :when) || Time.now).strftime "%Y%m%d"
    key_field = options.try(:[], :key) || "pv"
    key = genration_key(key_field)
    field = genration_field(key_field)
    n    = options.try(:[], :n) || 1

    #$redis.multi
    # 将总数移至 数据库
    # $redis.hincrby key, "total", n
    $redis.hincrby key, time, n
    update_attribute "#{field}", (count(options).to_i+1).to_i
    #$redis.exec[0]
  end

  # 取得PV值
  # params[:when => Time] || nil
  # 有则提取对应月份的PV访问量 | 无则提取所有PV值
  def pv(options = nil)
    options = (options.is_a?(Hash) ? options : {}).merge!({:key => "pv"})
    count(options)
  end
  
  # 取得下载数
  # params[:when => Time] || nil
  # 有则提取对应月份的download访问量 | 无则提取所有download值
  def download(options = nil)
    options = (options.is_a?(Hash) ? options : {}).merge!({:key => "download"})
    count(options)
  end
 
  # 取得打印数据
  # params[:when => Time] || nil
  # 有则提取对应月份的print访问量 | 无则提取所有print值
  def print(options = nil)
    options = (options.is_a?(Hash) ? options : {}).merge!({:key => "print"})
    count(options)
  end

  def discount_rate
    discount_amount / return_amount
  end
  def distributor_title
    Distributor.id_to_title(read_attribute('distributor_id'))
  end

  def shop_name
    Distributor::Shop.id_to_name(read_attribute('distributor_shop_id'))
  end

  def contract_options
    if distributor_id.to_i == 0
      [['请先选择经销商', 0]]
    else
      Distributor::Contract.by_distributor(distributor_id).valid.map{|d| [d.title, d.id]}.unshift(['请选择',''])
    end
  end
  
  def mark_deleted
    write_attribute('deleted', true)
    if save
      Distributor.decrement_counter(:coupons_count, distributor_id)
      complaints.each do |complaint|
        complaint.mark_deleted
      end
    end
  end
  
  # 将权多少取决于上面的 @@priority_value 变量值
  # 降权 升权 复权重
  # params[:act] boolean  true : 降权  false : 恢复权重
  def set_priority(act)
    unless self.priority.blank? 
      self.insert_at((act ? (self.priority - @@priority_value.to_i) : (self.priority + @@priority_value.to_i)), :value)
    end
  end

  # 撤销投诉 
  def revocation_complaint
    Distributor.decrement_counter(:complaints_count, distributor_id)
    Coupon.decrement_counter(:complaints_count, id)
    reload
    unless complaints_count >= 4
      update_attribute(:status, 1)
    end
  end

  # 确认投诉
  def confirm_complaint
    Distributor.increment_counter(:complaints_count, distributor_id)
    Coupon.increment_counter(:complaints_count, id)
    reload
    update_attribute(:status, 2) if complaints_count >=4
  end

  # 一周人气  key_
  # options[:week] 表示几周前
  def sort_key(options = nil)
    self.class.sort_key(options)
  end

  # redis zadd score
  def zadd_sorts
    n = downloads_count + prints_count
    city_code = if distributor_shop && distributor_shop.city
      distributor_shop.city.name
    else
      'shanghai'
    end
    key = sort_key({:tag_id => tag_id, :city_code => city_code})
    if !$redis.zadd(key, n, id)
      $redis.zincrby key, 1, id
    end
  end

  def create_print_properties
    begin
      CouponPrintProperty.create!(:coupon_id => self.id, :properties => '""')
    rescue
      retry
    end
  end
  private :create_print_properties

  # 人气指数根据下载数和打印数来变更
  def update_sort_value
    [:downloads_count, :prints_count].each do |count|
      if send(:"#{count}_changed?")
        change = send :"#{count}_change"
        self.sort += change.last - change.first
      end
    end
  end
  private :update_sort_value

  def update_brand_industry_name
    update_attribute(:brand_industry_name, (brand.name_zh + tag.short_name)) if self.brand_industry_name.blank? # 如果未输入名称则此处合成
  end
  private :update_brand_industry_name

  # 当修改抵用卷信息时调用此方法
  # 主要修改发行量值和现有数量的值 
  def update_total_issue_number_value(old_value, new_value)
    # 将新的发行量和旧的发行量转型
    old_value, new_value = old_value.to_i, new_value.to_i
    # 当旧值和新值不一样时做处理
    if old_value != new_value
      # 取得差值
      diff_value = 
          old_value < new_value ? (new_value - old_value) : (old_value - new_value)
      # 取得最终的剩余数量值
      new_existing = 
          old_value < new_value ? self.existing_number.to_i + diff_value : 
              self.existing_number.to_i - diff_value > 0 ? self.existing_number.to_i - diff_value : 0
      # 修改发行量和现有数量的值
      update_attributes(:total_issue_number => new_value, :existing_number => new_existing)
    end
  end

  # 生成 打印属性
  def print_properties
    coupon = self

    # 品类取short_name
    production_categories = coupon.production_categories
    #只取三个
    production_categories = production_categories[0..2]
    brand = coupon.brand
    tag = coupon.tag
    shop = coupon.distributor_shop
    city = City.find(coupon.city_id)
    district = District.find(shop.district_id)
    brand_detail = brand.detail_for(tag.TAGID) # => "BrandDetail"    print_image_url

    # @print_properties
    properties = {}
    # 抵用券自身属性
    properties["coupon_id"] = coupon.id
    properties["code"] = coupon.code
    properties["print_image_url"] = coupon.print_image_url.to_s.blank? ? '' : coupon.print_image_url.gsub("/", "")
    properties["discount_amount"] = coupon.discount_amount
    properties["return_amount"] = coupon.return_amount
    properties["activity_end_at"] = coupon.activity_end_at.to_date.strftime("%Y年%m月%d日")

    # 抵用券经销商全称
    properties["distributor_title"] = coupon.distributor.title
    # 品牌行业名
    properties["brand_industry_name"] = coupon.brand_industry_name

    # 门店
    # 若经销商店铺属于某一个卖场 则显示
    properties["shop_name"] = shop.name
    properties["shop_telphone"] = shop.telphone
    if shop.market_shop_id.nil?
      properties["shop_address"] = shop.address
    else
      market_shop = MarketShop.find(shop.market_shop_id)
      market = market_shop.market
      properties["shop_address"] = "#{market.name}(#{shop.address})"
    end

    # 品类文字
    properties["production_categories"] = production_categories.map(&:short_name).join(" ")

    # 品牌LOGO
    properties["logo"] = brand_detail.nil? ? "" : brand_detail.print_image_url.to_s.gsub("/", "")

    # 地区图标
    properties["area"] = district.code_name#district.code_name

    #城市
    properties["city"] = city.name

    # 行业
    properties["industry"] = tag.short_name

    # just for test preview
    city_print_properties = YAML::load($redis.get("coupon:print_properties:#{city.name}"))
    properties["area_color"] = city_print_properties['area_color'][district.code_name]
    # 行业color
    properties["tag_color"] = city_print_properties['industry_color'][tag.short_name]

    properties      
  end

end
