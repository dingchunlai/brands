class Dianping::DesignersController < Dianping::ApplicationController
  include PublicModule

  before_filter :vaildates_dianping_zhongduan_with_subdomain, :only => [:show]

  def show
    flash[:notice], flash[:error] = nil, nil
    @designer = CaseDesigner.find(params[:id], :include => [:deco_firm, :cs])
    @firm = @designer.deco_firm
    unless fragment_exist? "dianping:firm:designer:show:#{@designer.id}:right"
      @designers = CaseDesigner.firm_case_designer(@firm.id, 3, @designer.ID)
    end
    unless fragment_exist? "dianping:firm:designer:show:#{@designer.id}:bottom"
      @cases = @designer.cs.find(:all,:limit => 6)[1,5]
    end
    page_not_found! unless @designer.cs.size > 0
    @case = @designer.cs[0]
  end

  def new_case_remark
    remark = Remark.new(params[:remark])
    remark.ip=request.remote_ip
    remark.status = 1 if params["popedom"] == '1'
    if params["popedom"] != '-1'
      if remark.save
        if remark.parent_id
          remark_reply = Remark.find_by_id remark.parent_id
          remark_reply.update_attribute(:is_replied, true) if !remark_reply.is_replied
          remark = remark_reply
        end
        cases = HejiaCase.find_by_ID remark.resource_id
        if params[:remark][:resource_type] && params[:remark][:resource_id]
          if params["popedom"] == '1'
            flash[:error] = nil
            flash[:notice] = "提示：您已评论成功！"
          else
            flash[:error] = nil
            flash[:notice] = "提示：您发表的评论，需要审核之后才能显示，请耐心等待!"
          end
          render :partial => "/dianping/designers/case_remarks", :locals => { :cases => cases }
        else
          if params["popedom"] == '1'
            flash[:error] = "提示：您已回复成功！"
          else
            flash[:error] = "提示：您对评论发表的回复需要审核之后才能显示，请耐心等待!"
          end
          render :partial => "/dianping/designers/case_remark_replies", :locals => { :remark => remark }
        end
      else
        if params[:remark][:resource_type] && params[:remark][:resource_id]
          cases = HejiaCase.find params[:remark][:resource_id]
          flash[:error] = nil
          flash[:notice] = "您在一分钟内，不能频繁发表多次评论!"
          render :partial => "/dianping/designers/case_remarks", :locals => { :cases => cases }
        else
          remark = Remark.find params[:remark][:parent_id]
          flash[:error] = "您在一分钟内，不能频繁回复多次评论!"
          render :partial => "/dianping/designers/case_remark_replies", :locals => { :remark => remark }
        end
      end
    else
      if params[:remark][:resource_type] && params[:remark][:resource_id]
        cases = HejiaCase.find params[:remark][:resource_id]
        flash[:notice] = "对不起，目前本公司拒绝一切评论，敬请谅解！"
        render :partial => "/dianping/designers/case_remarks", :locals => { :cases => cases }
      else
        remark = Remark.find params[:remark][:parent_id]
        flash[:error] = "对不起，目前本公司拒绝一切评论，敬请谅解！"
        render :partial => "/dianping/designers/case_remark_replies", :locals => { :remark => remark }
      end
    end
  end
  
end