class UserController < Dianping::ApplicationController
  #判断是否6个月前打过分
  include PublicModule
  
  def verify_mark
    verify = remark_mark_verify(current_user.USERBBSID )
    is_mobile = !current_user.mobile_verified
    render :json => {:result => verify,
      :is_mobile => is_mobile
    }.to_json
  end
  
  #保存用户打分时间
  def add_remark_mark(user_id)
    $redis.setex("remark:mark:user:#{user_id}",6.months,1)
  end
  #判断6个月前是否评论过
  def remark_mark_verify(user_id)
    $redis.get("remark:mark:user:#{user_id}").nil? ? true : false
  end
  #判断验证码是否正确
  def mobile_code_verify(user_id ,code)
    get_code = $redis.get("mobile_code:#{user_id}")
    if get_code.nil?
      false
    else
      get_code.to_s == code.to_s ? true : false
    end
  end
  
  
  # 发送手机验证码
  def send_mobile_code
    mobile = params[:mobile]
    is_verify = HejiaUserBbs.find(:first,:conditions=>["USERBBSMOBELTELEPHONE = ? and mobile_verified = 1" , mobile]) #判断手机 是否绑定过

    mobile_key = "mobile_code:mobile:#{mobile}"
    user_key   = "mobile_code:user:#{current_user.USERBBSID}"

    if is_verify
      render :json => {:result => 4}.to_json #手机已绑定,验证失败
    elsif $redis.get(mobile_key)  # 手机没过3分钟限制
      render :json => {:result => 1}.to_json
    elsif $redis.get(user_key) # 用户没过3分钟限制
      render :json => {:result => 2}.to_json
    else


      code = rand(8999) + 1000
      verify_code = MobileCodeVerify.new
      verify_code.user_id = current_user.USERBBSID
      verify_code.user_mobile = mobile
      verify_code.resource_type = "FirmRemark"
      verify_code.verify_code = code
      verify_code.verify_status = false
      #判断是否是重发的
      first_verify_code = MobileCodeVerify.find(:first, :conditions => ["user_id=? and user_mobile=?", current_user.USERBBSID, mobile], :order => 'id desc')
      if first_verify_code && first_verify_code.created_at + 900 > Time.now
        a = ",您上次收到的验证码将自动失效."
      else
        a="."
      end
      logger.info "[Mobile] | #{mobile} | #{current_user.USERBBSID} | set limit!"
      $redis.setex mobile_key, 3.minutes, 1
      $redis.setex user_key,   3.minutes, 1
      $redis.setex "mobile_code:#{current_user.USERBBSID}" , 15.minutes , code

      if true === Hejia::SMS.send_text_message("您本次评分的验证码是：#{code}(验证码15分钟后失效)" + a , mobile)
        verify_code.send_status = true
        render :json => {:result => 0}.to_json   #成功发送验证码
      else
        verify_code.send_stauts = false
        render :json => {:result => 3}.to_json   #发送验证码失败
      end
      verify_code.save
    end
  end
  
  
  
  def validate_username
    username = HejiaUserBbs.find_by_USERNAME(params[:username])
    if username.nil?
      render :json=>{:result => 1}.to_json 
    else
      render :json=>{:result => 0}.to_json 
    end
  end
  
  def validate_email
    email = HejiaUserBbs.find_by_USERBBSEMAIL(params[:email])
    if email.nil?
      render :json=>{:result => 1}.to_json 
    else
      render :json=>{:result => 0}.to_json 
    end
  end
  
  def get_image_code
    expires_now
    validate_image = ValidateImage.new(4)
    image_code = validate_image.code
    session[:image_code] = image_code
   # Hejia::SMS.send_text_message "GET SESSION_ID:#{request.session_options[:id]} | CODE:#{code}", 13701895709
   logger.info "VERIFY SESSION_ID:#{request.session_options[:id]} | CODE:#{image_code}"
    send_data(validate_image.code_image, :type => 'image/jpeg')
  end
  
  def verify_mobile_code
    code = params[:code]
    mobile = params[:mobile]
    
    verify_code = MobileCodeVerify.find(:first, :conditions => ["user_id=? and verify_code=?", current_user.USERBBSID, code])
    verify = mobile_code_verify(current_user.USERBBSID ,code)
    HejiaUserBbs.update_all("mobile_verified = 1 , USERBBSMOBELTELEPHONE = #{mobile} ",:USERBBSID => current_user.USERBBSID) if verify
    verify_code.update_attribute(:verify_status, verify) if verify && verify_code
    render :json => {:result => verify}.to_json
  end
  
  def reg_save
    callback = params[:callback]
    image_code = session[:image_code]
    logger.info "VERIFY SESSION_ID:#{request.session_options[:id]} | CODE:#{image_code}"
    #Hejia::SMS.send_text_message "VERIFY SESSION_ID:#{request.session_options[:id]} | CODE:#{image_code}", 13701895709
    if params[:image_code].blank? || params[:image_code].to_s.strip != image_code
      if callback
        return render :text => "#{callback}({'error':'code'})", :content_type => Mime::JS
      else
        return render :json => {:result => 0}.to_json
      end
    end
    hub = HejiaUserBbs.new
    hub.USERNAME = iconv(params[:username])
    hub.USERBBSEMAIL = params[:userbbsemail]
    hub.BBSID = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
    hub.USERTYPE = 1
    hub.USERBBSSEX = iconv(params[:gender])
    params[:area] = nil if params[:area].blank?
    params[:city] = nil if params[:city].blank?
    hub.AREA = params[:area]
    hub.CITY = params[:city]
    hub.USERSPASSWORD = params[:userpassword]
    hub.CREATTIME = Time.now
    hub.HEADIMG = "http://member.51hejia.com/images/headimg/default.gif"
    session[:image_code] = nil
    if hub.save
      login_user! hub
      if callback
        render :text => "#{callback}('#{hub.USERBBSID}')", :content_type => Mime::JS
      else
        render :json=>{:result => 1}.to_json
      end
    else
      if callback
        render :text => "#{callback}({'error':'validate'})", :content_type => Mime::JS
      else
        render :json => {:result => 0}.to_json
      end
    end
      
  end
  
end
