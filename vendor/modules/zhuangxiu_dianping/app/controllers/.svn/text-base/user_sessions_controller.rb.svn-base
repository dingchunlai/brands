class UserSessionsController < Dianping::ApplicationController
  
  #用户登陆
  #此方法为API项目部分页面的用户登录验证。主要用于api项目ajax登录调用.和radmin项目的主登录方法有重复。
  #如今后用户登录发生变化。请注意同时修改此方法
  def user_login
    callback = params[:callback]
    name = params[:user_name]
    password = params[:password]
    days_from_now = params[:self_login].nil? ? 0 : 30
    hub = HejiaUserBbs.authenticate(name, password)
    if hub.nil?
      if callback
        render :text => "#{callback}('error')", :content_type => Mime::JS
      else
        render :text => 'error'
      end
    elsif hub.freeze_date && hub.freeze_date > Time.now
      if callback
        render :text => "#{callback}('freeze')", :content_type => Mime::JS
      else
        render :text => 'freeze' #账号冻结状态
      end
    else
      login_user! hub
       if callback
          render :text => "#{callback}('#{hub.USERBBSID.to_s}')", :content_type => Mime::JS
        else
          render :text => hub.USERBBSID.to_s #账号冻结状态
        end
    end
  end
  
  def pop_login
    render :layout => false
  end

  def diary_show_pop_login
    render :layout => false
  end
  
end
