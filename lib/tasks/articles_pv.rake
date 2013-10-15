desc "文章pv统计"
task :articles_pv => :environment  do
  puts "ready ..."
  #articles = Article.find(:all, :conditions => ["TODAY_PV <> 0 or YESTERDAY_PV <> 0"])
  begin_time = Time.now.to_s(:db)
  puts "开始时间:#{begin_time}"

  count = Article.count
  page_size = 500
  limit = page_size

  puts "total: #{count}篇文章"

  size = count/page_size
  for i in 0..size
    limit = count - size * page_size if i == size
    articles = Article.find(:all, :select => "ID,TODAY_PV,YESTERDAY_PV,SH_TODAY_PV,SH_YESTERDAY_PV", :order => "ID asc", :limit => limit, :offset => page_size * i)
    for article in articles
      article.YESTERDAY_PV = article.TODAY_PV
      article.SH_YESTERDAY_PV = article.SH_TODAY_PV
      article.save
      article.TODAY_PV = 0
      article.SH_TODAY_PV = 0
      article.save
    end
  end
  
  end_time = Time.now.to_s(:db)
  puts "结束时间:#{end_time}"
  seconds = end_time.to_time - begin_time.to_time
  puts "本次任务共用了#{seconds}秒"
  puts "end ..."
end