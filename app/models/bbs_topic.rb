class BbsTopic < Hejia::Db::Forum

  def title(length=99)
    strs = read_attribute("subject").to_s.split(//u)
    strs[0...length].join
  end

  def url
    "http://bbs.51hejia.com/btopic/#{id}"
  end

  class << self

    #论坛最新帖子
    def recent_topics(limit=5)
      max_limit = 10
      fail "limit最大不能超过max_limit" if limit > max_limit
      key = "key_bbs_topics_recent_topics_8_#{max_limit}"
      topics = Hejia[:cache].fetch(key, 2.hours) do
        BbsTopic.find(:all,
          :select => "id, subject, left(description,200) as description",
          :conditions => ["is_delete = 0 and user_id in (7252375, 7252378)"],
          :order => "created_at DESC", :limit => max_limit)
      end
      topics[0...limit]
    end

  end

end
