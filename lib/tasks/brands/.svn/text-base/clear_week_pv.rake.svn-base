namespace :zhuangxiudianping do
	desc "一周pv清零"
  task :clear_week_pv => :environment do
    if Date.today == Date.today.beginning_of_week
      desc "日记一周pv清零开始"
      DecorationDiary.connection.execute "update decoration_diaries set week_pv_count = week_pv;"
      DecorationDiary.connection.execute "update decoration_diaries set week_pv= 0;"
      desc "日记一周pv清零结束"

      desc "案例一周pv清零开始"
      HejiaCase.connection.execute "update HEJIA_CASE set week_pv_count = week_pv;"
      HejiaCase.connection.execute "update HEJIA_CASE set week_pv= 0;"
      desc "案例一周pv清零结束"
    end
  end
end



