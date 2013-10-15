desc "油工注册信息统计邮件"
task :yougong_zhuce_tongji_mail =>:environment  do
  
  puts "ready ..."
  puts "now time #{Time.now}"
  puts "star ..."
  
  now_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  week_time = 7.days.ago.strftime("%Y-%m-%d %H:%M:%S")
  
  recipient = ["Steven <jiyandong@51hejia.com>","Robin.Huang<huangyong@51hejia.com>"]
  title = "油工注册信息统计_#{Time.now.strftime('%Y-%m-%d')}"
  
  week_count = HejiaUserBbs.count(:all,:conditions => ["CREATTIME <= ? and CREATTIME >= ? and concerned_paint = 1",now_time , week_time])
  all_count = HejiaUserBbs.count(:all,:conditions => ["CREATTIME <= ? and concerned_paint = 1", now_time])

  content = "油工频道截止#{Time.now.strftime('%m月%d日%H时%M分')},共有注册人数#{all_count},"
  content << "上周（#{7.days.ago.strftime('%m月%d日%H时%M分')}--#{Time.now.strftime('%m月%d日%H时%M分')}）共注册#{week_count}人"

  mail = SendMailer.create_yougong_zhuce_tongji(recipient,title,content)
  mail.set_content_type("text/html")
  mail.charset = 'UTF-8'
  SendMailer.deliver(mail)

  puts "end"
end