class PaintApplicationController < AutoExpireController
  helper :all
  helper DecorationDiaryHelper
  include IpHelper
  skip_before_filter :get_promotion_items_for_layout, :brand_validation_filter
  
  
  def page_not_found!
    render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => 404
  end
  
  
  
  #  private ---------------------------华丽的分割线---------------------------------------
  private 
  #判断是否登陆
  def paint_worder_loggin?
    if user_logged_in?
      @paint_worker = PaintWorker.get_paint_worker current_user.id
       if @paint_worker.nil? || @paint_worker.painter.painters_status.to_i != 1
         false
       else
         true
       end
    else
      false
    end
  end

  
  #后台验证是否登陆
  def validate_admin
     redirect_to login_path unless paint_worder_loggin? 
  end
  
end