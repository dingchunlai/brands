class TaggedBrand < ActiveRecord::Base
  belongs_to :brand
  belongs_to :tag
  has_many :agencies

  include Votable
  
  # 投票信息的几个属性值
  cattr_accessor :vote_items 
  self.vote_items = %w[plain_buy strong_concern little_interest look_around not_interested]
  
  ITEM_VOTES = {"plain_buy" => "计划购买", "strong_concern" => "强烈购买", "little_interest" => "有点兴趣", "look_around" => "随便看看", "not_interested" => "没有兴趣" }
  
  # 随机取得number个标签
  def random_tags number
    size = $redis.zcard(tags_key)                           # 得到redis中存贮数据的个数
    start = size > number ? rand(size - number) : 0         # 确定开始数字
    tags = $redis.zrange(tags_key, start, start + number)   # 从redis中提取数据,返回一个数组。
    tags.sort! { rand(5) - 1 }
  end
  
  def template_name
    self.template == 'show_v1' ? '模板1' : '模板2(带点评)'
  end

  # pinpai_comments_tags_key
  def tags_key
    "tagged_brands:#{self.id}:tags:comments"
  end
  
  # 取得某品牌所关联经销商的所有城市信息
  # return []  Exmp:['上海', '全国', ...]
  def agencies_cities
    cities = agencies.all(:select => 'distinct(city)', :order => 'city').map!(&:city)
    code_of_the_whole_contry = City.the_whole_contry[0]
    if cities.delete(code_of_the_whole_contry)
      cities.unshift code_of_the_whole_contry
    end
    cities
  end
  
  # 得到品牌对应论坛的编号
  def brand_forum
    TaggedBrand.find(:first, :joins => "JOIN ")
  end

  # 因为所有信息存贮在redis中,所以生成一个KEY值 
  # 品牌投票的KEY值
  def vote_cache_key
    "tagged_brand:#{id}"
  end
  private :vote_cache_key
  
end
