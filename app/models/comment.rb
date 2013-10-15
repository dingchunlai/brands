class Comment < ActiveRecord::Base

  # validations
  validates_presence_of :tagged_brand_id, :message => "请选择品牌。"
  validates_presence_of :user_id, :message => "缺少用户信息。"
  validates_length_of :title, :in => 4..50, :message => "点评标题请保持在4 - 50个字符。"
  validates_length_of :body, :in => 1..999, :message => "评论内容请保持在1 - 999个字符。"

  validate :validates_tags

  # hooks
  after_create  :save_tags
  after_destroy :delete_tags
  before_validation :set_user_info

  # relationships
  has_many :comments, :foreign_key => 'parent_id', :order => "id asc"
  belongs_to :parent, :class_name => 'Comment', :counter_cache => true
  belongs_to :tagged_brand
  belongs_to :user, :class_name => 'HejiaUserBbs', :foreign_key => 'USERBBSID', :primary_key => 'user_id'

  default_scope :order => 'id desc'

  # named_scopes
  named_scope :all_comments, lambda { |tagged_brand_id, limit|
    {
      :conditions => ["parent_id is null and tagged_brand_id = ?", tagged_brand_id],
      :limit => limit
    }
  }
 
  # 得到品类，品牌下的所有评论
  named_scope :with_tagged_brand, lambda { |tagged_brand_id|
    {
      :conditions => ["parent_id is null and tagged_brand_id = ?", tagged_brand_id]
    }
  }

  named_scope :good_comments, lambda { |tagged_brand_id, limit|
    {
      :conditions => ["parent_id is null and remark >= 3 and tagged_brand_id = ?", tagged_brand_id],
      :limit => limit
    }
  }

  named_scope :bad_comments, lambda { |tagged_brand_id, limit |
    {
      :conditions => ["parent_id is null and remark < 3 and tagged_brand_id = ?", tagged_brand_id],
      :limit => limit
    }
  }

  #根据标签名获取点评
  named_scope :for_tag, lambda { |tag, limit |
    comment_ids = $redis.lrange self.comments_key_for_tag(tag), 0, -1
    {
      :conditions => ["id in (?)", comment_ids],
      :limit => limit
    }
  }

  # class methods
  class << self
    def rating_levels
      @rating_levels ||= [[0, '很差'], [1, '差'], [2, '一般'], [3, '满意'], [4, '很满意']]
    end

    def comments_key_for_tag tag
      "tags:#{tag}:tagged_brands:comments"
    end

    def comments_count(tagged_brand_id)
      self.count("id", :conditions => ["tagged_brand_id = ?", tagged_brand_id])
    end

  end # end class methods

  def remark_zh
    self.remark.to_i > 2 ? '好评' : '差评'
  end

  def tags
    @tags ||= $redis.smembers tags_key
  end

  def tags=(tags)
    if tags
      @tags = tags.is_a?(Array) ? tags : tags.split(' ')
      @tags.uniq!
    else
      @tags = nil
    end
    @tags
  end
  
  def tags_key
    "brands:comments:#{id}:tags"
  end

  def previous_comment
    Comment.find(:first,:select => 'id, title',:conditions => ["parent_id is null and id < ?", id])
  end

  def next_comment
    Comment.find(:first,:select => 'id, title',:conditions => ["parent_id is null and id > ?", id])
  end

  #点评投票(鲜花or鸡蛋)
  def comment_vote(type)
    count = 0
    if type=='support'
      write_attribute('support', support()+1)
      count = support() if save
    else
      write_attribute('oppose', oppose()+1)
      count = oppose() if save
    end
    count
  end

  private

  def save_tags
    begin
      $redis.multi
      tags.each do |tag|
        $redis.sadd tags_key, tag
        $redis.zincrby tagged_brand.tags_key, 1, tag
        $redis.rpush self.class.comments_key_for_tag(tag), id
      end
      $redis.exec
    rescue
      $redis.discard
      logger.error $!
      logger.error $@.join("\n")
    end
  end

  def delete_tags
    tags.each do |tag|
      $redis.zincrby tagged_brand.tags_key, -1, tag
      $redis.zrem tagged_brand.tags_key, tag if $redis.zscore(tagged_brand.tags_key, tag).to_i > 1
      $redis.lrem self.class.comments_key_for_tag(tag), 0, id
    end
    $redis.del tags_key
  end

  def set_user_info
    self.user_id = user.id if user_id.blank? && user
    self.user_name = user.USERNAME if user
  end

  def validates_tags
    errors.add 'tags', '每个标签不能超过5个字' if tags.any? { |tag| tag.mb_chars.size > 5 }
  end

end
