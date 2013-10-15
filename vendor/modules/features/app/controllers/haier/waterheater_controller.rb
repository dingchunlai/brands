class Haier::WaterheaterController < Haier::ApplicationController

  skip_filter :auto_expire
  before_filter :validates_rating,:only =>:rating,:if =>:is_hejia_ip?

  def solution
    %w[plan_first plan_second plan_third plan_four wasterecovery zerowater solarenergy resolveplan].each do |t|
      ['like','nolike'].each do |p|
        $redis.hexists("hejia:zhuanti:jiadian:Waterheater:haier:#{t}",p) ? instance_variable_set("@#{t}_#{p}",$redis.hget("hejia:zhuanti:jiadian:Waterheater:haier:#{t}",p)) : $redis.hset("hejia:zhuanti:jiadian:Waterheater:haier:#{t}",p,0)
      end
    end
    unless $redis.exists('hejia:zhuanti:jiadian:Waterheater:haier:followpeople')
       $redis.set('hejia:zhuanti:jiadian:Waterheater:haier:followpeople',200)
    end
    @follow_people = $redis.get('hejia:zhuanti:jiadian:Waterheater:haier:followpeople')
    $redis.set('hejia:zhuanti:jiadian:Waterheater:haier:followpeople',@follow_people.to_i + (20..50).to_a.sort_by {rand}[0])
    @topics = AskZhidaoTopic.get_wenba_weiyudianqi(132)
    @msgs = Remark.find(:all,:select =>'id,user_id,content',:include =>:hejia_bbs_user,:conditions =>'resource_type=\'haier_zhuanti_jiadian_waterheater\' and resource_type=0',:order =>'created_at desc',:limit =>50)
  end

  #投票
  def rating
    if request.post? && params[:item] && (['1','0'].include? params[:like])
      @tag = params[:like] == '1' ? 'like' : 'nolike'
       case params[:item]
       when 'plan_first';set_case_like('plan_first')
       when 'plan_second';set_case_like('plan_second')
       when 'plan_third';set_case_like('plan_third')
       when 'plan_four';set_case_like('plan_four')
       when 'wasterecovery';set_case_like('wasterecovery')
       when 'zerowater';set_case_like('zerowater')
       when 'solarenergy';set_case_like('solarenergy')
       when 'resolveplan';set_case_like('resolveplan')
       else
          return render(:text =>'请确保是否在页面上点击提交!')
       end
    else
      return render(:text =>'请确保是否在页面上点击提交!')
    end
    render :partial => true, :content_type => Mime::JS
  end

  #专题发表留言
  def create
      if params[:uchecked] == '1'
        messageok
      elsif !params[:uname].blank? && !params[:upwd].blank?
        name = params[:uname].to_s.strip
        password = params[:upwd].to_s.strip
        hub = HejiaUserBbs.authenticate(name, password)
        if hub
          login_user!(hub)
          messageok
        else
          return render(:text =>'用户名或密码错误!')
        end
      else
        return render(:text =>'请先登录或者匿名发表!')
      end
  end


  private

  def set_case_like(item)
     add_set_key = "hejia:zhuanti:jiadian:Waterheater:haier:#{item}"
     if params[:like] == '1'
       if !is_hejia_ip?
         $redis.hset(add_set_key,'like',$redis.hget(add_set_key,'like').to_i + 50)
       else
         $redis.hexists(add_set_key,'like') ? $redis.hincrby(add_set_key,'like',1) : $redis.hset(add_set_key,'like',0)
       end
     else
       $redis.hexists(add_set_key,'nolike') ? $redis.hincrby(add_set_key,'nolike',1) : $redis.hset(add_set_key,'nolike',0)
     end
  end


  def messageok
    @remark = Remark.new
    @remark.content = params[:ucontent]
    current_user ? @remark.user_id = current_user.USERBBSID : @remark.user_id = 7360706 # 匿名用户提交,指定一个.
    @remark.ip = request.remote_ip
    @remark.resource_type = 'haier_zhuanti_jiadian_waterheater'
    @remark.resource_id = 0
    @remark.status = 1
    @remark.created_at = @remark.updated_at = Time.now
    if @remark.save
      logout_user! if current_user
      render :partial => true, :content_type => Mime::JS
    else
      return render(:text =>'请稍后再提交!')
    end
  end



  # 防止恶意投票。
  def validates_rating
    cache_key = "haier/reshuiqi/diaocha/#{request.ip}/#{params[:item]}/#{params[:like]}"
    if Rails.cache.read(cache_key)
      render :text => "感谢您的参与，但您已经参与过这个投票了。\n(注：24小时内，同一个项目仅能进行一次有效的投票)", :status => 403
    else
      Rails.cache.write cache_key, true, :expires_in => 1.day
    end
  end

  def is_hejia_ip?
    !['58.246.26.58','127.0.0.1'].include? request.ip
  end

end