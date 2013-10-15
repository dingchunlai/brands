desc "商家购买文章pv统计"
task :zx_merchant_buy_pv => :environment  do
  puts "ready ..."
  begin_time = Time.now.to_s(:db)
  puts "开始时间:#{begin_time}"
  
  count = ZxMerchantBuy.count("status=0")
  page_size = 500
  limit = page_size

  puts "total: #{count}篇文章"

  size = count/page_size
  
  for i in 0..size
    limit = count - size * page_size if i == size
    zmbs = ZxMerchantBuy.find(:all, :select => "id,art_yes_view,art_today_view,advs_yes_view,advs_today_view,designers_yes_view,designers_today_view", :conditions => ["status=0"], :order => "ID asc", :limit => limit, :offset => page_size * i)
    for zmb in zmbs
      zmb.art_yes_view = zmb.art_today_view
      zmb.advs_yes_view = zmb.advs_today_view
      zmb.designers_yes_view = zmb.designers_today_view
      zmb.save
      zmb.art_today_view = 0
      zmb.advs_today_view = 0
      zmb.designers_today_view = 0
      zmb.save
    end
  end
  
  end_time = Time.now.to_s(:db)
  puts "结束时间:#{end_time}"
  seconds = end_time.to_time - begin_time.to_time
  puts "本次任务共用了#{seconds}秒"
  puts "end ..."
end