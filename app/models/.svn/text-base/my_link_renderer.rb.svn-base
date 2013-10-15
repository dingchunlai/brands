class MyLinkRenderer < WillPaginate::LinkRenderer

  protected

  def url_for(page)
    params = @template.controller.params
    controller_name = params["controller"]
    action_name = params["action"]
    if controller_name == "coupons" && action_name == "index"
      return "?page=#{page}"
    elsif controller_name == "articles" && action_name == "detail"
      return "/#{params[:channel]}/#{params[:date]}/#{params[:id]}-#{page}"
    else
      super(page) #调用WillPaginate的默认生成的url
    end
  end
  
end