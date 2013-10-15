desc "发送邮件"
task :send_mail_paint_admin =>:environment  do
  
  #send_times = $redis.SMEMBERS("paint_worker:admin:mail:send_time")
  send_times = ["10", "20", "11", "21", "12", "22", "13", "23", "14", "24", "15", "16", "17", "18", "19", "1", "2", "3", "4", "5", "6", "7", "8", "9"] 
  puts send_times.map{|i| "#{i}--" }
  puts "ready ...."
  if send_times.include? Time.now.hour.to_s
    puts "all star ..."
    paint_workers = PaintWorker.mail_show
    if paint_workers.size > 0
      puts "send paint_worker application_mail star... "
      recipient = $redis.GET("paint_worker:admin:mail:application_mail")
      title = "油漆工申请名单 _from_hejia_#{Time.now.strftime("%Y%m%d%H%M")}"
      email = SendMailer.create_paint_workers(recipient, title)
      email.set_content_type("text/html")
      email.charset = 'UTF-8'
      SendMailer.deliver(email)
      
      puts "update mail_type....."
      paint_workers.each do |worker|
        EmailDeliveryRecord.create!(:resource => worker)
      end
      puts "application_mail end ..."
    else
      puts "not application_mail"
    end
    
    lists = PaintSend.mail_show
    if lists.size > 0
      puts "send paint_worker answer_mail star... "
      recipient_paiqian = $redis.GET("paint_worker:admin:mail:answer_mail")
      title = "在线派遣申请名单_from_hejia_#{Time.now.strftime("%Y%m%d%H%M")}"
      paiqian = SendMailer.create_paiqian(recipient_paiqian, title)
      paiqian.set_content_type("text/html")
      paiqian.charset = 'UTF-8'
      SendMailer.deliver(paiqian)
    
      puts "update mail_type....."
      lists.each do |send|
        EmailDeliveryRecord.create!(:resource => send)
      end
      puts "answer_mail end ...."
    else
      puts "not answer_mail ...."
    end
    
    trainings = PaintTraining.mail_show
    if trainings.size > 0
      puts "send paint_worker study_mail star... "
      recipient_training = $redis.GET("paint_worker:admin:mail:study_mail")
      title = "在线培训申请名单_from_hejia_#{Time.now.strftime("%Y%m%d%H%M")}"
      training = SendMailer.create_training(recipient_training, title)
      training.set_content_type("text/html")
      training.charset = 'UTF-8'
      SendMailer.deliver(training)
    
      puts "update mail_type....."
      trainings.each do |t|
        EmailDeliveryRecord.create!(:resource => t)
      end
      puts " study_mail end... "
    else
      puts "not study_mail..."
    end
    
    cases = PaintCase.status_is(0).mail_show
    if cases.size > 0
       # @cases = $redis.GET("paint_worker:admin:mail:cases_mail")
      puts "send paint_worker cases_mail star...."
      recipient_cases = $redis.GET("paint_worker:admin:mail:cases_mail")
      title = "未审核案例_from_hejia_#{Time.now.strftime("%Y%m%d%H%M")}"
      training = SendMailer.create_audit_paint_cases_mail(recipient_cases, title)
      training.set_content_type("text/html")
      training.charset = 'UTF-8'
      SendMailer.deliver(training)
      puts "update cases_mail....."
      cases.each do |t|
        EmailDeliveryRecord.create!(:resource => t)
      end
      puts " cases_mail end... "
    else
      puts "not cases_mail..."
    end
        
    puts "all end ..."
    
  else
    puts "no send..."
  end
  
end