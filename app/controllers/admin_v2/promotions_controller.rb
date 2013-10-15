#促销活动管理后台
class AdminV2::PromotionsController < AdminV2Controller

  def index
    promotion = SalesPromotionEvent
    @subject = params[:subject].to_s.strip
    @tag_id = params[:tag_id].to_i
    @brand_id = params[:brand_id].to_i
    @brand_tag = Tag.first(:conditions => ['TAGID = ?', @tag_id]) if @tag_id > 0
    default_start_day = "2000-01-01"
    today = Time.now.strftime("%Y-%m-%d")
    @event_start = params[:event_start]
    @event_end = params[:event_end]
    @event_start = default_start_day if @event_start.blank?
    @event_end = today if @event_end.blank?

    cond = []
    cond << "subject like '%#{@subject}%'" unless @subject.blank?
    cond << "begins_at >= '#{@event_start}'" unless @event_start.blank? || @event_start == default_start_day
    cond << "ends_at <= '#{@event_end}'" unless @event_end.blank? || @event_end == today

    if @brand_id > 0
      promotion = Brand.find(@brand_id,:select=>"id").sales_promotion_events
    else
      promotion = Tag.find(@tag_id,:select=>"TAGID").sales_promotion_events if @tag_id > 0
    end
    
    @promotions = promotion.paginate :conditions => cond.join(" and "),
      :order => "id desc",
      :per_page => 15,
      :page => page
  end

  def new
    @promotion = SalesPromotionEvent.new
    @tag_ids = @brand_ids = []
    render :action => :edit
  end
  
  def edit
    @promotion = SalesPromotionEvent.find(params[:id])
    @tag_ids = @promotion.tags.map{|r| r.TAGID}
    @brand_ids = @promotion.brands.map{|r| r.id}
  end

  def create
    @promotion = SalesPromotionEvent.new(params[:promotion])
    if @promotion.save
      @promotion.update_location_latlng
      @promotion.tags = Tag.find(:all, :select=>"TAGID", :conditions => ["TAGID in (?)", params[:tag_ids]])
      @promotion.brands = Brand.find(:all, :select=>"id", :conditions => ["id in (?)", params[:brand_ids]])
      flash[:notice] = '促销活动添加成功!您可以继续添加！'
      redirect_to new_admin_promotion_path
    else
      flash[:alert] = "促销活动添加失败! <br /> #{@promotion.errors.full_messages.join('<br />')}"
      @tag_ids = @brand_ids = []
      render :action => :edit
    end
  end

  def update
    @promotion = SalesPromotionEvent.find(params[:id])
    @promotion.attributes = params[:promotion]
    location_changed = @promotion.location_changed?
    if @promotion.save
      @promotion.update_location_latlng if location_changed
      @promotion.tags = Tag.find(:all, :select=>"TAGID", :conditions => ["TAGID in (?)", params[:tag_ids]])
      @promotion.brands = Brand.find(:all, :select=>"id", :conditions => ["id in (?)", params[:brand_ids]])
      flash[:notice] = '促销活动更新成功!'
      redirect_to edit_admin_promotion_path(@promotion)
    else
      flash[:alert] = "促销活动更新失败!<br /> #{@promotion.errors.full_messages.join('<br />')}"
      @tag_ids = @promotion.tags.map{|r| r.TAGID}
      @brand_ids = @promotion.brands.map{|r| r.id}
      render :action => :edit
    end
  end

  def destroy
    @promotion = SalesPromotionEvent.find(params[:id])
    @promotion.destroy
    page = params[:page].to_i
    page = 1 unless page > 0
    redirect_to admin_promotions_path + "?page=#{page}"
  end

end
