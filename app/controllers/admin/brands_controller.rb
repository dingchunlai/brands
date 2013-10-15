class Admin::BrandsController < AdminController

  def index
    default_start_day = "2000-01-01"
    today = Time.now.strftime("%Y-%m-%d")
    @created_start = params[:created_start]
    @created_end = params[:created_end]
    @created_start = default_start_day if @created_start.blank?
    @created_end = today if @created_end.blank?
    find_options = {
      :select => 'product_brands.id, name_zh, is_hidden, created_at, updated_at',
      :include => :tagged_brands,
      :page => page
    }
    cd1, cd2 = [], []
    unless params[:name_zh].blank?
      cd1 << "name_zh like ?"
      cd2 << "%#{params[:name_zh]}%"
    end
    unless @created_start.blank? || @created_start == default_start_day
      cd1 << "created_at >= ?"
      cd2 << @created_start
    end
    unless @created_end.blank? || @created_end == today
      cd1 << "created_at <= ?"
      cd2 << @created_end
    end
    find_options[:conditions] = [cd1.join(" and ")].concat(cd2)
    tag_id = params[:tagid].to_i
    if tag_id == 0
      brands = Brand
    else
      brands = Brand.of_tag(tag_id, true) # 需要包括已经下线的。
    end
    @brands = brands.paginate find_options
  end

  def new
    @brand = Brand.new
    render :action => :edit
  end

  def create
    # 品类信息
    tags = params[:brand].delete(:tags) || []

    # 创建brand
    @brand = Brand.new params[:brand]
    tags.each do |k, v|
      @brand.tagged_brands.build :tag_id => k.to_i
    end

    if @brand.save
      flash[:notice] = '品牌添加成功'
      redirect_to admin_brands_path
    else
      flash[:alert] = '品牌添加失败'
      render :action => :edit
    end
  end

  def edit
    @brand = Brand.find params[:id]
    Brand.get_tags(@brand)
  end

  def update
    @brand = Brand.find params[:id]
    # 更新品类信息
    tags = params[:brand].delete(:tags) || []
    @brand.update_tags(tags.map { |k, v| k.to_i })
    
    production_categories = params[:brand].delete(:categories) || []
    @brand.update_categories(production_categories.map { |k, v| k.to_i })

    # 更新其它信息
    @brand.attributes = params[:brand]
    if @brand.save
      flash[:notice] = '品牌更新成功'
      redirect_to admin_brands_path
    else
      flash[:alert] = '品牌更新失败'
      render :action => :edit
    end
  end
  
  # params[:tag_id] 品类编号
  # return Brand_detail  品牌和品类详细信息
  def detail
    @brand = Brand.find params[:id], :include => [:details, :logos, {:tagged_brands => :tag}]
    tagged_brands = @brand.tagged_brands
    @tag_id = params[:tag_id] || tagged_brands.first && tagged_brands.first.tag_id
    if @tag_id.blank?
      head 403
    else
      @tag_id = @tag_id.to_i
      @tag = Tag.find @tag_id
      @brand_logo =  @brand.logos.first(:conditions => ["tag_id = ?", @tag_id])
      @brand_detail = @brand.detail_for @tag_id
      @brand_template = tagged_brands.find_by_tag_id(@tag_id).template rescue "show_v1"
      @htmlmetadata = HtmlMetadata.find_by_url(show_pinpai_url(@brand.permalink, :subdomain => @tag.TAGURL)) || HtmlMetadata.new
    end
  end
  
  def update_detail
    @brand_template = params[:brand_template]
    @tag_id = params[:tag_id]
    @brand = Brand.find params[:id], :include => [:details, :logos]
    @brand_detail = @brand.detail_for @tag_id
    @brand_detail.update_attributes params[:brand_detail]
    @brand_logo = @brand.logos.first(:conditions => ["tag_id = ?", @tag_id])

    #更新品牌的模板
    tagged_brand = @brand.tagged_brands.find_by_tag_id(@tag_id)
    tagged_brand.template = @brand_template
    tagged_brand.save

    # 更新品牌LOGO图片
    unless (logo = params[:logo]).blank?
      @brand_logo.destroy if @brand_logo
      @brand.logos << BrandPicture.new(
        :uploaded_data => logo,
        :brand_id => @brand.id,
        :tag_id => @tag_id
      )
    end

    # 更新对应品牌页面的属性
    unless params[:html_metadata][:title].blank? && params[:html_metadata][:keywords].blank? && params[:html_metadata][:description].blank?
      tag = Tag.find_by_TAGID @tag_id
      url = show_pinpai_url @brand.permalink, :subdomain => tag.TAGURL
      htmlmetadata = HtmlMetadata.find_by_url(url) || HtmlMetadata.new
      htmlmetadata.attributes = params[:html_metadata]
      htmlmetadata.url = url
      htmlmetadata.save
    end

    if @brand.save
      flash[:notice] = '品牌详细信息已更新'
      redirect_to admin_brands_path
    else
      flash[:alert] = '品牌详细信息更新失败'
      render :action => :detail
    end
  end

  def destroy
    Brand.destroy params[:id]
    flash[:notice] = '品牌已删除'
    redirect_to admin_brands_path
  end

  def display
    change_visibility true
  end

  def hide
    change_visibility false
  end

  def change_visibility(visible)
    if Brand.update params[:id], :is_hidden => !visible
      flash[:notice] = '品牌状态已改变'
    else
      flash[:alert] = '品牌状态改变失败'
    end

    redirect_to :action => :index
  end

  # GET/POST /admin/brands/:id/rating
  # 显示、编辑品牌的口碑评价信息
  def rating
    @brand = Brand.find params[:id], :include => [:ratings,{:tagged_brands => :tag}]
    @tag_id = params[:tag_id].to_i && params[:tag_id] || @brand.tagged_brands.first.tag_id
    @tag = Tag.find @tag_id
    @brand_rating = @brand.rating_for(@tag_id)
    @tagged_brand = TaggedBrand.find(:first, :conditions => ["tag_id = ? and brand_id = ?", @tag_id, @brand.id])
    @pv_weight = @brand.pv_weight(@tag_id)
    if request.post?
      if @brand_rating.update_attributes params[:rating]
        flash[:notice] = '口碑评价更新成功'
      else
        flash[:alert] = '口碑评价更新失败'
      end
    end
  end

  def pv_weight
    @brand = Brand.find params[:id]
    tag_id = params[:tag_id]
    begin
      @brand.set_pv_weight(tag_id, params[:number])
      flash[:notice] = "修改品牌基数值成功"
    rescue Exception => e
      flash[:alert] = "操作失败 :#{e}"
    end
    redirect_to rating_admin_brand_path(@brand, :tag_id => tag_id)
  end

  #开通论坛板块
  def create_bbs
    begin
      tag_id = params[:tag_id]
      brand_id = params[:id]
      brand = Brand.find(brand_id)
      parent_bbs_tag = BbsTag.find(:first, :select=>"id", :conditions=>["brand_tag_id = ? and brand_id is null", tag_id])
      BbsTag.create(:name => brand.name_zh, :parent_id => parent_bbs_tag.id, :brand_tag_id => tag_id, :brand_id => brand_id)
      flash[:notice] = "已为品牌【#{brand.name_zh}】开通了论坛板块"
    rescue Exception => e
      flash[:alert] = "操作失败：#{e}"
    end
    redirect_to tag_brands_admin_tag_path(tag_id)
  end

  #关闭论坛板块
  def close_bbs
    begin
      tag_id = params[:tag_id]
      brand_id = params[:id]
      BbsTag.delete_all(["brand_tag_id = ? and brand_id = ?", tag_id, brand_id])
      flash[:notice] = "论坛板块关闭操作成功"
    rescue Exception => e
      flash[:alert] = "操作失败：#{e}"
    end
    redirect_to tag_brands_admin_tag_path(tag_id)
  end
  
  def month_pv
    if request.xhr?
      unless params[:id].blank? && params[:tag_id].blank? && params[:time].blank?
        brand = Brand.find_by_id params[:id]
        pv = brand.last_month_pv(params["tag_id"], params["time"])
        render :json => {:pv => pv, :is_success => 1}
      else
        render :json => {:is_success => 0}
      end
    else
      render :json => {:is_success => 0}
    end
  end

  # 后台设置品牌购买意向数值
  def attention
    if request.post?
      tagged_brand = TaggedBrand.find_by_id params[:tagged_brand_id]
      items= TaggedBrand.vote_items
      tagged_brand.set_attention(items[0], params[items[0]]) if params[items[0]].to_i != 0
      tagged_brand.set_attention(items[1], params[items[1]]) if params[items[1]].to_i != 0
      tagged_brand.set_attention(items[2], params[items[2]]) if params[items[2]].to_i != 0
      tagged_brand.set_attention(items[3], params[items[3]]) if params[items[3]].to_i != 0
      tagged_brand.set_attention(items[4], params[items[4]]) if params[items[4]].to_i != 0
      flash[:notice] = "购买意向修改成功"
      redirect_to rating_admin_brand_path(tagged_brand.brand, :tag_id => tagged_brand.tag_id)
    else
      flash[:alert] = "购买意向修改失败"
      redirect_to :action => :rating
    end
  end
 
  # 修改品牌关注信息
  def update_pv
    begin
      @brand = Brand.find params[:id]
      tag_id = params[:tag_id]
      unless params[:date_time].blank? && params[:month_pv].to_i != 0
        @brand.update_pv(tag_id, params[:date_time], params[:month_pv].to_i)
      end
      flash[:notice] = "品牌关注度修改成功"
    rescue Exception => e
      flash[:alert] = "操作失败 :#{e}"
    end
    redirect_to rating_admin_brand_path(@brand, :tag_id => tag_id)
  end
end
