namespace :diary_votes_summary do
	desc "日记当月投票清零"
  task :diary=>:environment  do
    if Time.now.month != Time.now.yesterday.month
      name_by_keys = {
        "id" => "日记ID",
        "USERNAME" => "作者",
        "title" => "标题",
        "votes_sum" => "总投票",
        "votes_current_month" => "当月投票",
        "name_zh" => "所属公司"
      }
      shanghai_array = DecorationDiary.find_by_sql("SELECT d.id,b.USERNAME,d.title,d.votes_sum,d.votes_current_month,f.name_zh FROM decoration_diaries d, deco_firms f, HEJIA_USER_BBS b where d.deco_firm_id=f.id and d.is_verified=1 and f.city=11910 and b.USERBBSID=d.user_id order by d.votes_current_month desc limit 20")
      other_array = DecorationDiary.find_by_sql("SELECT d.id,b.USERNAME,d.title,d.votes_sum,d.votes_current_month,f.name_zh FROM decoration_diaries d, deco_firms f, HEJIA_USER_BBS b where d.deco_firm_id=f.id and d.is_verified=1 and f.city<>11910 and b.USERBBSID=d.user_id order by d.votes_current_month desc limit 20")
      csv_data = FasterCSV.generate do |csv|
        csv << name_by_keys.keys.sort.collect { |key| name_by_keys[key].to_s }
        shanghai_array.each do |cd|
          csv << name_by_keys.keys.sort.collect { |key| cd.send(key).to_s}
        end
        other_array.each do |cd|
          csv << name_by_keys.keys.sort.collect { |key| cd.send(key).to_s}
        end
      end
      File.open("/tmp/每月日记投票数汇总.csv", 'w') {|f| f.write(csv_data)}
      diary_id = 0
      while (diaries = DecorationDiary.find(:all,:conditions => ["votes_current_month > 0 and id>#{diary_id}"], :limit => '100')).size > 0
        p "从日记ID为#{diary_id}开始的100篇"
        diaries.each do |diary|
          diary.class.connection.execute "UPDATE #{diary.class.table_name} SET votes_current_month = 0 where id=#{diary.id}"
          $redis.set "diary/show/#{diary.id}/dangyuetoupiao", '0'
          diary_id = diary.id
        end
      end
    end
  end
end



