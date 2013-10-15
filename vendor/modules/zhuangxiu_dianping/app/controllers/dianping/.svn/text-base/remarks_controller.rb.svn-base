class Dianping::RemarksController < Dianping::ApplicationController
  include PublicModule

  helper 'dianping/firms'
  
  def pop_form
    @remark = Remark.new
    @firm_id = params[:firm_id]
    render :layout => false
  end
  
  def firm_remarks_ajax_list
    @remarks = Remark.paginate(:all, :conditions => ["status = 1 and resource_type = 'DecoFirm' and resource_id = ?", params[:id]],
      :order => "created_at desc", :page=>params[:page], :per_page => 10 )
    @firm = DecoFirm.find(params[:id])
    render :partial =>'/dianping/firms/remarks_list'  ,:layout=>false 
  end

  def create
    if current_user && current_user.latest_remark && current_user.latest_remark.created_at >= 1.minute.ago
      return render :text => "不能发表多次评论"
    end
    @remark = Remark.new(params[:remark])
    @remark.user_id = current_user.USERBBSID
    @remark.ip = request.remote_ip
    @remark.status = 1 if params[:popedom] == '1'
    if params[:popedom] != '-1'
      if @remark.save
        @remarks = @remark.resource.show_remarks.paginate(:all,:page => params[:page],:per_page=>10)
        render :partial => "/dianping/shared/remarks_list"
      else
        render :text => "alert('保存失败')"
      end
    end
  end

  def firm_remark_save
    flash[:notice] = nil
    if params[:remark][:resource_id]
      @firm = DecoFirm.find(params[:remark][:resource_id])
    elsif params[:remark][:parent_id]
      @firm = DecoFirm.find(Remark.find(params[:remark][:parent_id]).resource_id)
    end
    if @firm.popedom != -1
      @remark = Remark.new(params[:remark])
      @remark.created_at = Time.now
      @remark.ip = request.remote_ip
      @remark.user_id = current_user.USERBBSID
      #判断是否是留言
      if params[:remark][:resource_id]
        @remark.resource_type = "DecoFirm"
        this_mobile = params[:this_mobile]
        if @remark.praise > 0
          if params[:zuimanyi] == "设计"
            @remark.design_praise = 10
          elsif params[:zuimanyi] ==  "施工"
            @remark.construction_praise = 10
          elsif params[:zuimanyi] == "服务"
            @remark.service_praise = 10
          end
          if params[:jiaomanyi] == "设计"
            @remark.design_praise = 9
          elsif params[:jiaomanyi] ==  "施工"
            @remark.construction_praise = 9
          elsif params[:jiaomanyi] == "服务"
            @remark.service_praise = 9
          end
          if params[:zuimanyi] && params[:jiaomanyi]
            @remark.design_praise = 8 if @remark.design_praise == 0
            @remark.construction_praise = 8 if @remark.construction_praise == 0
            @remark.service_praise = 8 if @remark.service_praise == 0
          end
        end
      end
      @remark.status = 1 if @firm.popedom == 1
      if @remark.save
        remark_id = @remark.resource ? @remark.resource.id : @remark.parent.id
        expire_fragment("firm:remarks:#{remark_id}:")
        if @remark.resource_type == "DecoFirm"
          if @remark.praise.to_i > 0
            current_user.update_attributes(:USERBBSMOBELTELEPHONE => this_mobile ,:mobile_verified => 1) unless current_user.mobile_verified
            add_remark_mark(current_user.id )
            return redirect_to :back if params[:submit_type] == "pop"
          end
          @remarks = Remark.paginate(:all, :conditions => ["status = 1 and resource_type = 'DecoFirm' and resource_id = ?", @firm.id],
            :order => "created_at desc", :page=>params[:page], :per_page => 10 )
          if @firm.popedom == 0
            flash[:notice] = "提示：您发表的评论，需要审核之后才能显示，请耐心等待!"
            render :partial =>'/dianping/firms/remark_form', :layout=>false
          elsif @firm.popedom == 1
            flash[:notice] = "您已评论成功，谢谢！"
            render :partial =>'/dianping/firms/remarks_list'
          end
        elsif @remark.parent_id.to_i > 0
          remark = Remark.find(@remark.parent_id)
          remark.update_attribute(:is_replied, true) if !remark.is_replied
          return redirect_to(:back) if params[:submit_type] == "pop"
          flash[:success] = "提示：您对评论发表的回复需要审核之后才能显示，请耐心等待!" if @firm.popedom == 0
          render :partial => "/dianping/firms/firm_post_remark_replies", :locals => { :remark => remark }
        end
      else
        if @remark.resource_type == "DecoFirm"
          @remarks = Remark.paginate(:all, :conditions => ["status = 1 and resource_type = 'DecoFirm' and resource_id = ?", @firm.id],
            :order => "created_at desc", :page=>params[:page], :per_page => 10 )
          if @remark.praise.to_i > 0
            flash[:notice] = "提示：对不起.您6个月只能评论一次"
          else
            flash[:notice] = "提示：您在一分钟内，不能频繁发表多次评论!"
          end
          if @firm.popedom == 0
            render :partial =>'/dianping/firms/remark_form', :layout=>false
          elsif @firm.popedom == 1
            render :partial =>'/dianping/firms/remarks_list'
          end
        elsif @remark.parent_id.to_i > 0
          remark = Remark.find(@remark.parent_id)
          render :partial => "/dianping/firms/firm_post_remark_replies", :locals => { :remark => remark }
        end
      end
    else
      render :text => alert("对不起，目前本公司拒绝一切评论，敬请谅解！") + js("history.back(-1);")
    end
  end
  
end