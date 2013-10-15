desc "得到昨天日记的评论数"
task :update_yesterday_remark_count =>:environment  do
  
   puts "ready ..."
   puts "清空以前的数据"
   clean_diaries = DecorationDiary.find(:all,:conditions => 'yesterday_remarks > 0')
   puts "要清空#{clean_diaries.size}条"
   DecorationDiary.update_all("yesterday_remarks = 0","yesterday_remarks > 0")
   puts "清空...end"
   sql = "SELECT decoration_diaries.id , COUNT(remarks.resource_id) AS remarks_count FROM remarks "
   sql << "INNER JOIN decoration_diary_posts ON decoration_diary_posts.id = remarks.resource_id AND remarks.resource_type = 'DecorationDiaryPost'"
   sql << "JOIN decoration_diaries ON decoration_diaries.id=decoration_diary_posts.decoration_diary_id "
   sql << "WHERE remarks.created_at >= '#{1.day.ago.strftime('%Y-%m-%d')} 00:00:00' AND remarks.created_at <= '#{Time.now.strftime('%Y-%m-%d')} 00:00:00' "
   sql << "GROUP BY decoration_diaries.id"
   diaries = DecorationDiary.find_by_sql(sql)
   puts "共要修改#{diaries.size}条记录"
   puts "star ..."
   diaries.each do |diary|
     DecorationDiary.update_all("yesterday_remarks = #{diary.remarks_count}","id = #{diary.id}")
   end
   puts "end ..."
end