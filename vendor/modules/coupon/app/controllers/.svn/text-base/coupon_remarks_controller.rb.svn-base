# encoding: utf-8

# Front CouponRemark

class CouponRemarksController < CouponApplicationControllerController

  def create
    # do not use current_user && current_user.USERBBSID , or try
    if current_user
      @remark_id = params[:remark_id].to_i
      @remark = CouponRemark.new(params[:coupon_remark])
      @remark.user_id = current_user.USERBBSID
      @remark.ip = request.env["HTTP_X_FORWARDED_FOR"] || request.env['REMOTE_ADDR']
      @remark.parent_id = @remark_id if @remark_id > 0
      #    if @remark_id == 0 #添加评论
      respond_to do |format|
        if @remark.save
          format.html { redirect_to(request.env["HTTP_REFERER"], :notice => "success") }
          format.js {}
        else
          format.html { redirect_to(request.env["HTTP_REFERER"], :notice => @remark.errors.full_messages.join("<br />")) }
          format.js {
            render :update do |page|
              page.replace_html 'error_message_for_comment', @remark.errors.full_messages.join("<br />")
            end
            return
          }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to(request.env["HTTP_REFERER"], :notice => "请先登录再提交评论！") }
        format.js { }
      end
    end

  end
end
