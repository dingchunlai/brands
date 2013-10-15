class Brand < ActiveRecord::Base

  COMMENT_FORM_ID = 83
  VISITS_RATE_BY_HOUR = [2.59, 1.14, 0.68, 0.45, 0.44, 0.47, 0.88, 1.46, 3.34, 5.31, 6.47, 6.22, 5.01, 5.50, 6.21, 6.73, 6.84, 5.65, 4.46, 5.14, 6.53, 7.35, 6.69, 4.44]
  TAG_BASE_NUMBER = [["油漆涂料",571],["地板",476],["卫浴洁具",556],["橱柜/厨具",357],["厨房电器",476],["吊顶",179]]

  set_table_name 'product_brands'

  attr_accessor :tags, :production_categories

  # relationships
  has_many :logos,   :class_name => 'BrandPicture', :dependent => :destroy
  has_many :details, :class_name => 'BrandDetail', :dependent => :destroy
  
  # 因为我们不需要直接调用这个关系，所以改一下命名方式，作为一个内部的方法来使用。
  has_many :ratings, :class_name => 'BrandRating', :dependent => :destroy
  has_many :tagged_brands, :dependent => :destroy
  has_many :production_series, :class_name => 'ProductionSeries', :dependent => :destroy
  has_many :brands_production_categories, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_and_belongs_to_many :sales_promotion_events

  # hooks
  before_create :set_defaults
  after_save :initializer_initial

  validates_presence_of :name_zh, :permalink
  validates_uniqueness_of :permalink

  # named scopes
  default_scope :order => 'priority, name_en, created_at'

  named_scope :enabled, :conditions => ["is_hidden=?", false]

  named_scope :for_tag, lambda { |tag_id, include_hidden, select|
    tag_id = tag_id.TAGID if tag_id.is_a?(Tag)
    {
      :select => select,
      :joins => 'JOIN tagged_brands ON product_brands.id = tagged_brands.brand_id',
      :conditions => (
        include_hidden ?
          ['tagged_brands.tag_id = ?', tag_id] :
          ['product_brands.is_hidden = ? and tagged_brands.tag_id = ?', false, tag_id]
      )
    }
  }

  # 可以根据检索字母进行查询品牌
  # 具体字段 initial
  named_scope :with_initial, lambda {|initial|
    {
      :conditions => (initial.blank? ? nil : ["product_brands.initial = ? or product_brands.initial = ?", initial.upcase, initial.downcase])
    }
  }

  # 根据品牌进行模糊查询
  named_scope :with_name_zh, lambda { |name_zh|{
      :conditions => ['name_zh LIKE ?', "%#{name_zh}%"]
    }
  }

  class << self

    def record_by_id(id)
      id.to_i > 0 ? self.first(:select => 'id, name_zh', :conditions => ['id = ?', id]) : nil
    end

    def id_to_name(object)
      object = record_by_id(object) if object.class != self
      return '' if object.nil?
      object.name_zh
    end

    #根据品牌名称获的品牌id
    def brand_id_by_name(brand_name)
      brand_name = brand_name.to_s.strip
      brand_id = 0
      unless brand_name.blank?
        brand = Brand.find(:first, :select=>"id", :conditions=>["name_zh = ? or name_en = ?", brand_name, brand_name])
        brand_id = brand.id unless brand.nil?
      end
      return brand_id
    end

    # 找出属于某个品类的品牌。
    # @param [Integer] tag_id 品类id
    # @param [Boolean] include_hidden 是否包括下线了的品牌
    def of_tag(tag_id, include_hidden = false, select = nil)
      for_tag tag_id, include_hidden, select
    end

    # 找出品牌所属的行业，并且把找到的品类赋值到tags属性中。
    # 参数可以是一个或者多个品牌实例，也可以是一个品牌实例数组。
    # * 注：由于分属于不同的库，只能这样做了。
    def get_tags(*brands)
      brands.flatten!
      tag_ids = brands.map { |brand| brand.tagged_brands.map(&:tag_id) }.flatten!
      tags = Industry.all(:conditions => ['TAGID in (?)', tag_ids]).inject({}) do |hash, tag|
        hash[tag.TAGID] = tag
        hash
      end
      brands.each do |brand|
        brand.tags = brand.tagged_brands.map { |tagged_brand| tags[tagged_brand.tag_id] }
      end
      brands.each do |brand|
        brand.production_categories = brand.brands_production_categories.map { |brand_category| brand_category.production_category }
      end
    end

    # 得到含有该品牌名称的所有问题以及答案
    def get_questions_answers(brand,p_name=nil)
      questions = Question.find(:all,
        :select => "id, subject, user_id, best_post_id, created_at, last_reply_time",
        :conditions => ["is_delete = 0 and is_close = 0 and post_counter >= 1 and subject like ?", "%#{brand.name_zh}#{p_name}%"],
        :include => :answers,
        :limit => 6,
        :order => "last_reply_time desc")
      if questions.size < 6
        questions += Question.find(:all,
          :select => "id, subject, user_id, best_post_id, created_at, last_reply_time",
          :conditions => ["is_delete = 0 and is_close = 0 and post_counter >= 1 and subject like ?", "%#{brand.name_en}%"],
          :include => :answers,
          :limit => (6 - questions.size),
          :order => "last_reply_time desc")
      end
      questions
    end

    # 取得某品类的上个月关注度排名前几位的品牌。
    # @param [Tag, integer] tag_or_tag_id 品类或者品类的id
    # @param [Integer] limit 前几位
    def last_month_tops_of(tag_or_tag_id, limit)
      tag_id = tag_or_tag_id.is_a?(Tag) ? tag_or_tag_id.id : tag_or_tag_id
      ids =  $redis.zrevrange(
        rank_pv_key(tag_id, last_month),
        0, limit - 1
      ).map!(&:to_i)

      brands = find ids

      ids.map! { |id| brands.detect { |b| b.id == id.to_i } }
    end

    # 投票
    def increase_vote(tagged_brand, attr)
      $redis.hincrby "tagged_brands:#{tagged_brand}:votes:trends", "#{attr}", 1
    end
  
    # 将上一个月日期格式化 | (201008)
    def last_month
      1.month.ago.strftime("%Y%m")
    end

    def rank_pv_key(tag_id, time)
      "rank:#{tag_id}:brands:#{time}"
    end
  end

  # ====== 分界线：以上class methods；以下：instance methods ===================

  # 该品牌页浏览数(关注度)递增
  # @example
  # some_brand.increase_pv! tag.TAGID
  # some_brand.increase_pv! tag.TAGID, :when => 1.month.ago, :n => 10
  def increase_pv!(tag_id, options = nil)
=begin
    time = (options.try(:[], :when) || Time.now).strftime '%Y%m'
    n    = options.try(:[], :n) || 1
    $redis.hincrby pv_key(tag_id), "total", n
    $redis.hincrby pv_key(tag_id), time, n
    $redis.zincrby "brands:pv:#{tag_id}:total", n.to_i, id
=end
    $redis.multi
    $redis.hincrby pv_key(tag_id), "total", 1
    $redis.hincrby pv_key(tag_id), Time.now.strftime('%Y%m'), 1
    $redis.zincrby "brands:pv:#{tag_id}:total", 1, id
    $redis.exec[0]
  end
  
  # 重新计算上月的PV值
  def recalculate_last_moth_pv(tag_id)
    one_month_ago_pv = last_month_pv(tag_id)
    new_pv = pv_weight(tag_id) * Time.days_in_month(1.month.ago.month) + one_month_ago_pv * 30 / 100
    total = pv(tag_id) - one_month_ago_pv + new_pv
    $redis.hset pv_key(tag_id), "total", total
    $redis.hset pv_key(tag_id), last_month, new_pv
    $redis.zadd rank_pv_key(tag_id, last_month), new_pv, id
  end
 
  # 修改由于上次错误将总数添加到上月PV数中 || 现做修改
  def update_error_rank(tag_id, time = "201008")
    last_month_pv = $redis.hget pv_key(tag_id), time
    $redis.zadd(rank_pv_key(tag_id, time), last_month_pv, id) unless last_month_pv.blank?
  end

  # 修改某一个月的pv值
  # 修改某一月的PV值，关联两个信息。1.上月的PV。2.总的PV值
  # time => "201008"
  def update_pv(tag_id, time, new_pv)
    total = pv(tag_id) - last_month_pv(tag_id, time) + new_pv
    set_month_pv(tag_id, time, new_pv)
    $redis.hset pv_key(tag_id), "total", total
    $redis.zrem "brands:pv:#{tag_id}:total", id
    $redis.zincrby "brands:pv:#{tag_id}:total", total, id
    $redis.zadd rank_pv_key(tag_id, last_month), new_pv, id if time == last_month
  end

  #取得该品牌页浏览数(关注度)
  def pv(tag_id)
    $redis.hget(pv_key(tag_id), "total").to_i + 1
  end
  
  # 取得品牌基数值
  def pv_weight(tag_id)
    ($redis.get(pv_weight_key(tag_id)) || 1).to_i
  end

  # 设置品牌基数值
  def set_pv_weight(tag_id, number)
    $redis.set(pv_weight_key(tag_id), number)
  end
  
  # 取得该品牌页最近浏览数(关注度)
  def last_month_pv(tag_id, time = last_month)
    $redis.hget(pv_key(tag_id), time).to_i + 1
  end
  
  # 设置某一个月的PV值
  def set_month_pv(tag_id, time, new_pv)
    $redis.hset(pv_key(tag_id), time, new_pv)
  end

  # 取得该品牌页最近关注排名
  def last_month_rank(tag_id, time = last_month)
    #rank = $redis.zrevrank(rank_pv_key(tag_id, time), id)
    rank = $redis.zrevrank("brands:pv:#{tag_id}:total", id)
    rank && rank.to_i + 1 || 0
  end

  # 更新品牌所属的品类。
  # 先把原来的记录全部删除，再根据现在的状况重建创建。
  # __注意__ 这里只是创建了新的记录，并没有保存。
  def update_tags(tag_ids)
    tagged_brands.each do |tagged_brand|
      tagged_brand.destroy unless tag_ids.delete(tagged_brand.tag_id)
    end
    tag_ids.each { |tag_id| tagged_brands.build(:tag_id => tag_id) }
    self
  end
  
  # 修改品牌关联的产品分类信息
  # 做法同上 update_tags
  def update_categories(category_ids)
    brands_production_categories.each do |production_category|
      production_category.destroy unless category_ids.delete(production_category.production_category_id)
    end
    category_ids.each { |category_id| brands_production_categories.build(:production_category_id => category_id) }
    self
  end

  # 取得该品牌下，属于某一个品类的详细信息。如果当前没有该信息，则创建一个。
  # @param [Integer, Tag] tag 品类实例或者是品类的TAGID。
  def detail_for(tag)
    tag_id = tag.is_a?(Tag) ? tag.TAGID : tag
    details.first(:conditions => ["tag_id = ?", tag_id]) || details.create(:tag_id => tag_id)
  end
  
  # 根据品类对象或者品类编号 寻找出品牌和此品类相关的口碑信息对象  没有则创建
  # @params[Integer, Tag] 品类对象Tag 或者品类编号TAGID
  def rating_for(tag)
    tag_id = tag.is_a?(Tag) ? tag.TAGID : tag
    ratings.first(:conditions => ["tag_id = ?", tag_id]) || ratings.create(:tag_id => tag_id)
  end

  def rating_for_category(category)
    category_id = category.is_a?(ProductionCategory) ? category.id : category
    ratings.first(:conditions =>["category_id = ?",category_id]) || ratings.create(:category_id =>category_id,:tag_id =>0)
  end

  #根据品类编号，返回相应的论坛板块
  def bbs_tag(tag_id)
    BbsTag.find(:first, :conditions=>["brand_id = ? and brand_tag_id = ?", id, tag_id])
  end

  # 得到某个品牌下所有的品类集合
  def tags_for
    tag_ids = tagged_brands.map{|tb| tb.tag_id}
    tag_ids.length > 0 ? Industry.all(:conditions => ['TAGID in (?)', tag_ids]) : []
  end
 
  # 得到当前品牌状态名称
  def status_zh
    self.is_hidden ? "未上线" : "已上线"
  end

  def part_render_type(part_name)
    config = BRAND_SHOW_CONFIG[permalink.to_s]
    return 1 if config.nil? || config[part_name].nil?
    config[part_name]
  end

  ## 计算pv
  ## 默认波动比例10%，默认最小基本基数200（tmp_percentage是波动比例，tmp_base_number是基本基数）
  ## 先计算月基数month_base_number，然后计算每日基数day_base_number，根据访问波动峰值数组VISITS_RATE_BY_HOUR，计算每个小时时间段基数数组hour_base_number_array
  def self.increase_pv_number(brand,tag,hour,min)
    tmp_percentage = brand.percentage.blank? ? 10 :brand.percentage
    tmp_base_number = brand.base_number
    if brand.base_number.blank?
      tmp_base_number = TAG_BASE_NUMBER.assoc(tag.TAGNAME).blank? ? 200 : TAG_BASE_NUMBER.assoc(tag.TAGNAME)[1]
    end
    month_base_number = tmp_base_number + rand((tmp_base_number * tmp_percentage / 100.0).round)
    day_base_number = (month_base_number/Date.today.end_of_month.day.to_f).round

    ## =================================计算每个小时时间段基数数组开始=================================
    tmp_base_number = []
    i = 1
    24.times do
      tmp_base_number << (day_base_number * VISITS_RATE_BY_HOUR.first(i).sum / 100.0).round
      i += 1
    end

    hour_base_number_array = []
    j = 0
    24.times do
      if j == 0
        hour_base_number_array << tmp_base_number[0]
      else
        hour_base_number_array << tmp_base_number[j] - tmp_base_number[j - 1]
      end
      j += 1
    end
    ## =================================计算每个小时时间段基数数组结束=================================

    ## =================================计算每30分钟时间段基数数组开始=================================
    hour_base_number = hour_base_number_array[hour]
    tmp_qujian_base_number = []
    m = 1
    2.times do
      tmp_qujian_base_number << (hour_base_number * m / 2.0).round
      m += 1
    end

    qujian_base_number_array = []
    n = 0
    2.times do
      if n == 0
        qujian_base_number_array << tmp_qujian_base_number[0]
      else
        qujian_base_number_array << tmp_qujian_base_number[n] - tmp_qujian_base_number[n - 1]
      end
      n += 1
    end
    ## =================================计算每30分钟时间段基数数组结束=================================
    qujian_base_number_array[min/30]
  end

  ## 初始化排序
  def self.initializer_total_pv
    for tag in Tag.used_categories
      for brand in Brand.of_tag(tag.TAGID, false)
        $redis.zincrby "brands:pv:#{tag.id}:total", ($redis.hget("brands:#{brand.id}:pv:#{tag.id}", "total").to_i + $redis.zscore("brands:pv:#{tag.id}:total", brand.id).to_i.abs), brand.id
      end
    end
  end
  private

  def set_defaults
    self.is_hidden = true
  end
  
  # 品牌访问存贮的KEY值
  def pv_key(tag_id)
    "brands:#{id}:pv:#{tag_id}"
  end
  
  # 设置品牌基数值的KEY
  def pv_weight_key(tag_id)
    "brands:#{id}:pv:#{tag_id}:weight"
  end
  
  # 设置一个key
  def rank_pv_key(tag_id, time)
    self.class.rank_pv_key(tag_id, time) 
  end

  # 将上一个月日期格式化 | (201008)
  def last_month
    self.class.last_month
  end

  # 实例化initial 字段值
  def initializer_initial
    if self.initial.blank?
      first_name = self.name_zh.mb_chars.first.to_s
      if first_name =~ /^[a-zA-Z]/
        update_attribute :initial, first_name.downcase
      else
        en_name = ChineseDictionary.pinyin_for(first_name)
        update_attribute :initial, en_name.first unless en_name.blank?
      end
    end
  end

end
