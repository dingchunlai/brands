class Admin::PromotionCollectionsController < AdminController

  def resource_list
    @search_text = params[:search_text].to_s
    @search_type = params[:search_type].to_s
    @tagid = Tag.get_tagid_by_tagname(@search_type) unless @search_type.blank?
    @search_interval = params[:search_interval].to_i
    @search_interval = 1 if @search_interval == 0
    @item_type = params[:item_type].to_s
    @item_type = 'Article' if @item_type.blank?
    if @item_type == "SalesPromotionEvent"
      if @tagid.to_i > 0
        model = SalesPromotionEvent.for_tag(@tagid)
      else
        model = SalesPromotionEvent
      end
      conditions = []
      conditions << "subject like '%#{@search_text}%'" unless @search_text.blank?
      conditions << "ends_at > '#{@search_interval.months.ago.to_s(:db)}'"
      @rs = model.paginate(:select=>"id, subject as title, created_at",
        :per_page => 15,
        :conditions => conditions.join(" and "),
        :page => page,
        :order => "id desc")
    else
      if @tagid.to_i > 0
        model = Article.for_tag(@tagid)
      else
        model = Article
      end
      conditions = []
      conditions << "TITLE like '%#{@search_text}%'" unless @search_text.blank?
      conditions << "CREATETIME > '#{@search_interval.months.ago.to_s(:db)}'"
      @rs = model.paginate(:select=>"HEJIA_ARTICLE.id, HEJIA_ARTICLE.title, HEJIA_ARTICLE.CREATETIME as created_at",
        :per_page => 15,
        :conditions => conditions.join(" and "),
        :page => page,
        :order => "CREATETIME desc")
    end
    render :layout => false
  end

  def index
    @search = params[:search].to_s.strip
    cond = []
    cond << "name like '%#{@search}%' or code like '%#{@search}%'" unless @search.blank?
    @collections = PromotionCollection.paginate :conditions => cond.join(" and "),
      :order => "id desc",
      :per_page => 20,
      :page => page
  end

  def new
    if session[:is_hejia_admin]
      @collection = PromotionCollection.new
      render :action => :edit
    else
      render :text => "访问错误：只有管理员可以新建推广位！"
    end
  end

  def edit
    @collection = PromotionCollection.find(params[:id])
  end

  def create
    @collection = PromotionCollection.new(params[:collection])
    if @collection.save
      flash[:notice] = '推广位添加成功!'
      redirect_to new_admin_promotion_collection_path
    else
      flash[:alert] = '推广位添加失败!'
      render :action => :edit
    end
  end

  def update
    @collection = PromotionCollection.find(params[:id])
    @collection.attributes = params[:collection]
    if @collection.save
      flash[:notice] = '推广位更新成功!'
      redirect_to edit_admin_promotion_collection_path(@collection)
    else
      flash[:alert] = '推广位更新失败!'
      render :action => :edit
    end
  end

  def add_city
    unless City.code_for_name("全国").to_s == "quanguo"
      City.add('quanguo', '全国')
      City.add('shanghai', '上海')
      City.add('beijing', '北京')
      City.add('guangzhou', '广州')
      City.add('tianjin', '天津')
      City.add('chongqing', '重庆')
      City.add('hangzhou', '杭州')
      City.add('suzhou', '苏州')
      City.add('ningbo', '宁波')
      City.add('wuhan', '武汉')
      City.add('wuxi', '无锡')
      City.add('chengdu', '成都')
      City.add('zhengzhou', '郑州')
      City.add('nanjing', '南京')
      City.add('shenzhen', '深圳')
      City.add('hefei', '合肥')
      City.add('jinan', '济南')
      City.add('qingdao', '青岛')
      City.add('changsha', '长沙')
      City.add('nanchang', '南昌')
      City.add('shijiazhuang', '石家庄')
    end
    render :text => "城市添加完毕!"
  end

end
