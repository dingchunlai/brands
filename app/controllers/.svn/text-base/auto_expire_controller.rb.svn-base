# 自动过期
# 任何controller只要继承这个controller，就能获得自动在一定时间内过期的功能。
class AutoExpireController < ApplicationController
  class_inheritable_accessor :auto_expires_in
  self.auto_expires_in = 10.minutes

  after_filter :auto_expire if Rails.env.production? or Rails.env.rehearsal?

  private # There should not be any public methods in this controller

  def auto_expire
    if params[:dont_cache_me]
      expires_now
    else
      expires_in self.class.auto_expires_in, :public => true
    end
  end
end
