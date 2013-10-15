class Haier::OpinionController < Haier::ApplicationController

  def view_map

  end

  def up_down
    user_ip = request.remote_ip
    if $redis.get("haier:vote:user:#{user_ip}").nil?
      if params[:type] == 'up'
        key = "case/show/#{params[:id]}/caseup"
        num = $redis.incr key
        HejiaCase.update_all("CASEUP=#{num}", "ID=#{params[:id]}")
      else
        key = "case/show/#{params[:id]}/casedown"
        num = $redis.incr key
        HejiaCase.update_all("CASEDOWN=#{num}", "ID=#{params[:id]}")
      end
      $redis.setex("haier:vote:user:#{user_ip}",1.days,1) if user_ip != "58.246.26.58"
      render :text => num
    else
      render :text => "sorry"
    end
  end

end