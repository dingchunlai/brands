class Dianping::DecorationDiariesController < Dianping::ApplicationController

  include PublicModule
  before_filter :validate_diary ,:only => :show
  before_filter :vaildates_dianping_zhongduan_with_subdomain, :only => [:show]

  def index

    #现日记列表参数为params[:condition] params[:order]
    #排序为order ,检索条件为condition
    #其中检索条件condition为4个参数组成的字符串  room => 户型  ,  model => 装修方式  ,style => 装修风格 ,price => 装修价位
    #其中每根据索引对应的条件分别为 condition = {0 => model ,1 => style,2 => price,3 => room}
    #为了方面以后增加或减少查询条件.现用变量condition_size来注明几个参数
    condition_size = 4
    @order = params[:order]
    condition = params[:condition].blank? ? ("0" * condition_size) : params[:condition]
    conditions = condition.split(//)
    @model = conditions[0]
    @style = conditions[1]
    @price = conditions[2]
    @room = conditions[3]
    @page = params[:page]
    @diaries = DecorationDiary.diaries_list(@user_city_code)
    @diaries = @diaries.price_is(@price) if @price.to_i > 0
    @diaries = @diaries.style_is(@style) if @style.to_i > 0
    @diaries = @diaries.model_is(@model) if @model.to_i > 0
    @diaries = @diaries.room_is(@room) if @room.to_i > 0
    @diaries = @diaries.keyword_is(@keyword) if @keyword != '0' && !@keyword.nil?
    if @order.to_i == 0
      @diaries = @diaries.paginate :page => @page, :per_page => 6
    else
      @diaries = @diaries.verified_is(@order).paginate :page => @page, :per_page => 6
    end

    ## 一周pv最高的10条合作公司日记
    @topten_diaries = DecorationDiary.top_diaries(@user_city_code, 10)

    ## 合作公司日记Hot10 ：调用规则为一周 根据评论数排序,回复数排序,日记修改时间排序
    @hotten_diaries = DecorationDiary.hot_diaries(@user_city_code, 10)

    expires_in 5.minutes, :public => true
  end

  def show
    flash[:notice], flash[:error] = nil, nil
    @ad_space_base = "装修日记-终端页"
    @page = params[:page] ? params[:page] : 1
    @firm = @diary.deco_firm
    #unless fragment_exist?("diary:itself_informations:#{@diary_id}:#{@page}")
    @diary_posts = @diary.verified_diary_posts.paginate :page => @page, :per_page => 15
    #end
    #unless fragment_exist?("diary:itself_informations:#{@diary_id}:case")
      ###very slow need add key index
      #@case = @diary.hejia_case unless @diary.hejia_case.nil?
    #end

    ## 一周pv最高的10条日记
    @topten_diaries  = DecorationDiary.top_diaries(@user_city_code, 10)

    ## 该公司其他最新日记
    @related_diaries = @firm.related_diaries([@diary.id])

    render :partial => 'diary_info' if request.xhr?
  end

  #提交日记评论
  def new_diray_remark
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
        diary_post = DecorationDiaryPost.find_by_id remark.resource_id
        if params[:remark][:resource_type] && params[:remark][:resource_id]
          if params["popedom"] == '1'
            flash[:error] = nil
            flash[:notice] = "提示：您已评论成功！"
          else
            flash[:error] = nil
            flash[:notice] = "提示：您发表的评论，需要审核之后才能显示，请耐心等待!"
          end
          render :partial => "/dianping/decoration_diaries/diary_post_remarks", :locals => { :diary_post => diary_post }
        else
          if params["popedom"] == '1'
            flash[:error] = "提示：您已回复成功！"
          else
            flash[:error] = "提示：您对评论发表的回复需要审核之后才能显示，请耐心等待!"
          end
          render :partial => "/dianping/decoration_diaries/diary_post_remark_replies", :locals => { :remark => remark }
        end
      else
        if params[:remark][:resource_type] && params[:remark][:resource_id]
          diary_post = DecorationDiaryPost.find params[:remark][:resource_id]
          flash[:error] = nil
          flash[:notice] = "您在一分钟内，不能频繁发表多次评论!"
          render :partial => "/dianping/decoration_diaries/diary_post_remarks", :locals => { :diary_post => diary_post }
        else
          remark = Remark.find params[:remark][:parent_id]
          flash[:error] = "您在一分钟内，不能频繁回复多次评论!"
          render :partial => "/dianping/decoration_diaries/diary_post_remark_replies", :locals => { :remark => remark }
        end
      end
    else
      if params[:remark][:resource_type] && params[:remark][:resource_id]
        diary_post = DecorationDiaryPost.find params[:remark][:resource_id]
        flash[:notice] = "对不起，目前本公司拒绝一切评论，敬请谅解！"
        render :partial => "/dianping/decoration_diaries/diary_post_remarks", :locals => { :diary_post => diary_post }
      else
        remark = Remark.find params[:remark][:parent_id]
        flash[:error] = "对不起，目前本公司拒绝一切评论，敬请谅解！"
        render :partial => "/dianping/decoration_diaries/diary_post_remark_replies", :locals => { :remark => remark }
      end
    end
  end

  # 分页查询某个公司的日记信息
  def paginator
    firm = DecoFirm.getfirm params[:id]
    @diaries = firm.decoration_diaries.published.paginate :page => params[:page], :per_page => 5
    render :partial => "/dianping/firms/diaries"
  end

  #顶，踩用IP做限制
  def verify_ip
    id = params[:id]
    ip = request.remote_ip.to_s
    result = $redis.get("diary:verify:ip:#{ip}:#{id}").nil? ? true : false
    render :json => {:result => result}.to_json
  end

  # 验证是否已经透过票
  def valid_vote(diary_id, ip)
    #$redis.get("diary:verify:ip:#{ip}:#{diary_id}").nil? ? true : false
    $redis.get("diary:verify:ip:#{ip}:#{diary_id}").to_i > 4 ? false : true
  end
  private :valid_vote

  #投票
  def to_vote_for_me
    ip = request.remote_ip.to_s
    message = "投票成功，感谢您的参与"
    flg = "1"
    if diary = DecorationDiary.find(params[:reviewid])
      if valid_vote(diary.id, ip)
        DecorationDiary.cached_decoration_diaries diary # 更新缓存中的对象
        $redis.setex "diary:verify:ip:#{ip}:#{params[:reviewid]}", 24.hours , ($redis.get "diary:verify:ip:#{ip}:#{params[:reviewid]}").to_i + 1
        diary.class.connection.execute "UPDATE #{diary.class.table_name} SET votes_sum = #{diary.votes_sum + 1}, votes_current_month = #{diary.votes_current_month + 1} where id=#{diary.id}"
        riji = DecorationDiary.find(diary.id)
        $redis.set "diary/show/#{diary.id}/toupiao", riji.votes_sum
        $redis.set "diary/show/#{diary.id}/dangyuetoupiao", riji.votes_current_month
      else
        message = "对不起，您今天的投票次数已达到上限！"
        flg = "0"
      end
    end
    render :json => {:is_success => flg, :message => message}
  end

  #日记留言分页
  def remaks_page
    @diary_id = params[:id]
    @deco_name = DecorationDiary.getNote(@diary_id).deco_firm.name_abbr
    page = params[:page]
    page = 1 if page.nil?
    @remarks = DecorationDiary.remarks_paginate(@diary_id,page)
    render :partial => "/dianping/decoration_diaries/remarks"
  end

  def sort_diary_body
    @page = params[:page]
    diary = DecorationDiary.find_by_id params[:nid]
    order = params[:order] if params[:order] && (params[:order].to_i == 1 || params[:order].to_i == 2) #日记排序
    order = order && order.to_i == 2 ? "id desc" : "id asc"
    @diary_posts = diary.verified_diary_posts.paginate :page => params[:page], :per_page => 15, :order => order
    t_case = params[:t_case]
    if t_case == 'case'
      url = "/dianping/decoration_diaries/diary_post_show"
    else
      url = "/dianping/decoration_diaries/diary_posts"
    end
    render :partial => url, :locals => { :diary => diary, :page => @page, :diary_posts => @diary_posts }
  end

  private
  #验证日记状态
  def validate_diary
    @diary_id = params[:id]            # 日记编号
    @diary = DecorationDiary.find(@diary_id, :include => [:deco_firm, :verified_diary_posts])
    if @diary.nil?
      page_not_found!
    else
      unless @diary.status.to_i == 1
        page_not_found! unless params[:preview] && params[:preview] == "true"
      end
    end
  end

end
