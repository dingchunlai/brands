# 用户对品牌的印象
class Impression
  attr_accessor :title, :tagged_brand_id, :number

  # 最新印象列表中，保存多少条记录
  @@limit = 5

  class << self

    #印象排行榜
    def charts(tagged_brand_id, limit = 8)
      count = Impression.count(tagged_brand_id).to_f
      cs = []
      is = Impression.find tagged_brand_id, :limit => limit, :with_count => true
      0.step(limit*2-1, 2) do |i|
        cs << {:name=>is[i],:score=>is[i+1],:percent=>format('%.1f', is[i+1].to_f*100/count)+'%'}
      end
      cs
    end

    # 创建一条印象记录
    # @param [Hash] attributes 印象的属性
    # @option attributes [Integer] :tagged_brand_id TaggedBrand对象的id
    # @option attributes [TaggedBrand] :tagged_brand TaggedBrand对象，:tagged_brand和:tagged_brand_id选择其中一个使用即可。
    # @option attributes [String] :title 印象名称。
    # @option attributes [Integer] :number 印象数，可选，默认值是1。
    # @return [Boolean] true表示保存成功；false表示保存失败。
    def create(attributes)
      new(attributes).save
    end

    # 找出品牌印象。
    # @param [Integer] tagged_brand_id TaggedBrand对象的id
    # @param [Hash] options 选项
    # @option options [Integer] :limit 返回多少条记录
    # @option options [Boolean] :with_count 是否返回每一个印象的对应的计数
    def find(tagged_brand_id, options = nil)
      $redis.zrevrange impression_set_for(tagged_brand_id),
        0, (options.try(:[], :limit) || 0) - 1,
        :with_scores => options.try(:[], :with_count)
    end

    # 返回品牌所有印象的总计数（就是有多少人参加过印象点评）。
    def count(tagged_brand_id)
      # 如果redis有zscores之类的方法返回总分的话就方便了。
      $redis.get(counter_for(tagged_brand_id)).to_i
    end

    # 返回最新添加的若干条印象
    # 由@@limit决定有多少条
    def latest(tagged_brand_id)
      $redis.zrevrange latest_list_for(tagged_brand_id), 0, -1
    end

    def impression_set_for(tagged_brand_id)
      "tagged_brands:#{tagged_brand_id}:impressions"
    end

    def counter_for(tagged_brand_id)
      "tagged_brands:#{tagged_brand_id}:impressions:counter"
    end

    def latest_list_for(tagged_brand_id)
      "tagged_brands:#{tagged_brand_id}:impressions:latest"
    end

  end

  def initialize(attributes)
    attributes.each do |field, value|
      send "#{field}=", value
    end
  end

  def tagged_brand=(tagged_brand)
    @tagged_brand = tagged_brand
    self.tagged_brand_id = tagged_brand.id
  end

  def tagged_brand
    @tagged_brand ||= TaggedBrand.find_by_id(tagged_brand_id)
  end

  def errors
    @errors ||= ActiveRecord::Errors.new(self)
  end

  def valid?
    errors.empty?
  end

  def save
    normalize_attributes
    validates

    valid? && create
  end

  private

  def normalize_attributes
    self.title = title.strip if title
    self.number ||= 1
  end

  def validates
    errors.add_to_base('请填写印象') if title.blank?
    errors.add_to_base('印象不能超过5个字') if title.mb_chars.size > 5
    errors.add_to_base('得票数必须是个整数') unless number.is_a?(Integer)
    errors.add_to_base('得票数不能少于1') if number.is_a?(Integer) && number < 1
    errors.add_to_base('请选择品牌') if tagged_brand_id.blank?
  end

  def create
    $redis.multi
    # 给品牌添加印象，包括这个印象的得票数(ordered set)
    $redis.zincrby self.class.impression_set_for(tagged_brand_id), number, title
    # 增加品牌的印象的总得票数，即所有印象的得票数的总和(string)
    $redis.incrby self.class.counter_for(tagged_brand_id), number

    # 处理最新添加的印象(ordered set)
    latest_list = self.class.latest_list_for tagged_brand_id
    $redis.zadd latest_list, Time.now.to_i, title
    $redis.zrem latest_list, $redis.zrange(latest_list, 0, 0).first if $redis.zcard(latest_list).to_i > @@limit
    $redis.exec
    true
  rescue
    Rails.logger.error $!
    Rails.logger.error $@.join("\n")
    $redis.discard
    false
  end

end
