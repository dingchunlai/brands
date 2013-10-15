desc "计算日记总评论数"
task :update_diary_remarks_count =>:environment  do
  
   puts "ready ..."
   sql = "SELECT decoration_diaries.id , COUNT(remarks.resource_id) AS remarks_count FROM remarks "
   sql << "INNER JOIN decoration_diary_posts ON decoration_diary_posts.id = remarks.resource_id AND remarks.resource_type = 'DecorationDiaryPost'"
   sql << "JOIN decoration_diaries ON decoration_diaries.id=decoration_diary_posts.decoration_diary_id and  decoration_diaries.status = 1 "
   sql << "GROUP BY decoration_diaries.id "
   diaries = DecorationDiary.find_by_sql(sql)
   puts "共要修改#{diaries.size}条记录"
   puts "star ..."
   diaries.each_with_index do |diary, index|
     if index/100 > 0 && index%100 == 0
       puts "完成#{index}条........."
     end
     DecorationDiary.update_all("remarks_count = #{diary.remarks_count}","id = #{diary.id}")
   end
   puts "end ..."
end