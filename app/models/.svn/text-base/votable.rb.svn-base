# 用户对品牌的投票
module Votable 
  # 用户点击某种类型进行投票
  # params[:vote_cache_key] 品牌和品类关联编号
  # params[:attr] 类型
  # 对投票数自加1
  def vote_for(attr, number = 1)
    $redis.hincrby redis_key, attr, number
  end
 
  # 重新设置数值
  def set_attention(attr, number)
    $redis.hset redis_key, attr, number
  end

  # 得到投票数
  # params[:vote_cache_key] 品牌和品类关联编号
  # params[:attr] 某一类型的值   如:品牌终端页投票类型
  # return Integer
  def vote_count_for(attr)
    $redis.hget(redis_key, attr).to_i
  end
 
  def style_width attr
    most_voted.blank? ? 0 : (vote_count_for(attr).to_f / most_voted * 100).round 
  end

  # 获得所有的投票值 
  # 返回一个HASH对
  # exp: hash[key] = value
  def all_votes
    $redis.hgetall redis_key
  end
  
  # 获取当前最大值
  def most_voted
    $redis.hvals(redis_key).map!(&:to_i).max
  end

  def redis_key
    "votes:#{vote_cache_key}"
  end
  private :redis_key
end
