class AskBlogTopic < Hejia::Db::Hejia

  self.table_name = "ask_blog_choices"

  def self.recent_logs
    key = "key_publish_recent_blogs_#{Time.now.strftime('%Y%m%d%H')}"
    Hejia::Cache.fetch(key, 5.days) do
      AskBlogTopic.find(:all,
        :conditions => ["sort_id = 6 and is_valid = 2"],
        :order => "order_number DESC, updated_at DESC", :limit => 5)
    end
  end
  
end
