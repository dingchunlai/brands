class PaintAdmin::MailController < PaintAdmin::AdminController
  
#   load_and_authorize_resource
  
  def index
    @send_time = $redis.SMEMBERS("paint_worker:admin:mail:send_time")
    @application = $redis.GET("paint_worker:admin:mail:application_mail")
    @study = $redis.GET("paint_worker:admin:mail:study_mail")
    @answer = $redis.GET("paint_worker:admin:mail:answer_mail")
    @cases = $redis.GET("paint_worker:admin:mail:cases_mail")
  end
  
  def update_config
    send_times, application, study, answer,cases = params.values_at(:send_times, :application, :study, :answer,:cases)
    send_times = [12,16] if send_times.blank? #如果没有值默认12点和16点
    $redis.DEL("paint_worker:admin:mail:send_time")
    send_times.each do |time|
      $redis.SADD("paint_worker:admin:mail:send_time",time)
    end
    $redis.SET("paint_worker:admin:mail:application_mail",application)
    $redis.SET("paint_worker:admin:mail:study_mail",study)
    $redis.SET("paint_worker:admin:mail:answer_mail",answer)
    $redis.SET("paint_worker:admin:mail:cases_mail",cases)
    flash[:notice] = "修改成功"
    redirect_to :action => :index
  end
  
  def test_mail
    recipient = $redis.GET("paint_worker:admin:mail:application_mail")
    title = "油漆工申请名单  #{Time.now}  -----测试测试"
    email = SendMailer.create_sent(recipient, title)
    email.set_content_type("text/html")
    email.charset = 'UTF-8'
    SendMailer.deliver(email)
    render :text => "<ul><li>" + (email.methods.sort - Object.methods).join("<li>") + "</ul>"
  end
  

end