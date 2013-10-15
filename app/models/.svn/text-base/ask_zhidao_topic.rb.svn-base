class AskZhidaoTopic < Hejia::Db::Hejia
  
  #某会员的问题列表
  named_scope :user_answer,lambda{ | user_id | 
    zhidao_post = "SELECT zhidao_topic_id FROM ask_zhidao_topic_posts WHERE (user_id = #{user_id} and is_delete = 0)"
    {
      :select => "id, subject, best_post_id, post_counter,view_counter, created_at",
      :conditions => [" (id in (#{zhidao_post}) or interrogee = #{user_id}) and is_delete = 0" ],
      :order => "id desc",
    }
  }
  
  def title(length=99)
    strs = read_attribute("subject").to_s.split(//u)
    strs[0...length].join
  end

  def url
    "http://wb.51hejia.com/q/#{id}.html"
  end

  #问吧最新帖子
  def self.recent_topics(limit=5)
    max_limit = 10
    fail "limit最大不能超过max_limit" if limit > max_limit
    key = "ask_zhidao_topics_recent_topics"
    topics = Hejia[:cache].fetch(key, 2.hours) do
      AskZhidaoTopic.find(:all,
        :select => "id, subject, left(description,150) as description",
        :conditions => ["is_delete = 0 and is_distribute = 1"],
        :order => "created_at DESC", :limit => max_limit)
    end
    topics[0...limit]
  end

  def self.user_answer(user_id)
    key = "haier_zhuanti_designer_#{user_id}_asks"
    Hejia[:cache].fetch(key, 2.hours) do
      zhidao_post = "SELECT zhidao_topic_id FROM ask_zhidao_topic_posts WHERE (user_id = #{user_id} and is_delete = 0)"
      AskZhidaoTopic.find(:all,
        :select => "id, subject, best_post_id, post_counter,view_counter, created_at",
        :conditions => [" (id in (#{zhidao_post}) or interrogee = #{user_id}) and is_delete = 0" ],
        :order => "id desc")
    end
  end

  #海尔调查页面 获取问吧 建材 >> 厨房卫浴 >>卫浴电器 数据

  def self.get_wenba_weiyudianqi(tagid)
    Hejia[:cache].fetch('haier_zhuanti_jiadian_waterheater_haier',5.minutes) do
      find(:all,:select =>'id,subject,description',:conditions => ['tag_id=?',tagid],:order =>'updated_at desc',:limit =>10)
    end
  end

end