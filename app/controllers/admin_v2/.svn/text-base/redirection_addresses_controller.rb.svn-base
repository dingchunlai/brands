class AdminV2::RedirectionAddressesController < AdminV2Controller
 
  # 一个重定向action 并发操作将请求url存入session中
  def goto
    session[:back] = request.env["HTTP_REFERER"]
    redirect_to params[:url]
  end

  # 根据session中的url进行跳转
  def back
    url = session[:back]
    session[:back] = nil
    redirect_to url
  end

end
