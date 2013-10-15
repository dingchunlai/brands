class HuodongController < AutoExpireController

  before_filter :parse_params, :only => :list

  #活动首页
  def index
    @end_page_name =  "活动促销"
    @used_tags = Tag.used_categories
  end

  def zhaoshang
    @end_page_name = "招商加盟"
  end

  def zhixiao
    @end_page_name = "厂商直销"
    @underway_events = SalesPromotionEvent.underway.find(:all, :select=>"id,subject,city,begins_at", :limit=>9)
    @news = Article.find(
        :all,
        :select => "ID,FIRSTCATEGORY,CREATETIME,IMAGENAME,TITLE,SUMMARY,CREATETIME",
        :conditions => ["SECONDCATEGORY = ? and STATE = '0'", 42992],
        :order => "ID DESC",
        :limit => 10
        )
  end

  def detail
    @id = params[:id]
    @event = SalesPromotionEvent.find(@id)
    @hot_events = SalesPromotionEvent.find(:all, :order => "id desc", :limit => 5)
    #@hot_events = PromotionCollection.published_items_for("活动:终端页:火热活动")
    #@unstart_events = SalesPromotionEvent.unstart.find(:all, :select=>"id,subject", :limit=>8)
  end

  #活动列表页
  def list
    @used_tags = Tag.used_categories
    if @scope == "expired"
      @events = SalesPromotionEvent.expired
    else
      @events = SalesPromotionEvent.unexpired
    end
    @events = @events.for_city(@city) unless @city.blank?
    tag_id = Tag.get_tagid_by_tagurl(@tagurl)
    @events = @events.for_tag(tag_id) if tag_id > 0

    @events = @events.paginate :per_page => 9, :page => page

    #如果第一页就没有记录，且未强制指定scope类型。
    if @events.length == 0 && page.to_i < 2 && params[:scope].nil?
      #自动跳转到“已结束”类型（因为在未强制指定scope类型时候，默认查询的是“未结束”类型的活动）
      #return redirect_to request.env['REQUEST_PATH'] + "?scope=expired"
      return redirect_to huodong_list_path(@city, :scope => 'expired')
    end

    #取4条火热活动，带图片
    #@hot_events = PromotionCollection.published_items_for("活动:列表页:火热活动")
    pi_ids = PromotionCollection.published_items_for("活动:列表页:火热活动").map{|pi|pi.resource_id}
    @hot_events = SalesPromotionEvent.find(pi_ids[0,4])

    @unstart_events = SalesPromotionEvent.unstart.find(:all, :select=>"id,subject", :limit=>8)
  end

  def parse_params
    @city, @tagurl = params.delete(:args).first.try :split, '_', 2
    @scope = (params[:scope].nil?) ? 'unexpired' : params[:scope]
  end
  private :parse_params

end
