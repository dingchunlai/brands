# encoding: utf-8
# add For Coupon 
class AdminV2::BrandsController < AdminV2Controller
  
  before_filter :validate_tagged_brand, :only => [:rating, :detail, :update_detail, :html_meta, :update_html_meta, :template, :promotion_pages, :promotion_page, :create_promotion_page, :update_promotion_page, :promotion_collections_page, :impressions, :second_category]
 
  before_filter :loaded_with_information, :only => [:manage, :edit, :update]

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
    @tag = Tag.categories.find_by_TAGID params[:tag_id] unless params[:tag_id].blank?
    render :action => :edit
  end
  
  # 当添加品牌时：如果没有选择品类则进入首页，若选择了多个品类则会默认进入最后一个品类和品牌相关联页面
  def create
    @tag = Tag.categories.find_by_TAGID params[:tag_id] unless params[:tag_id].blank?
    # 品类信息
    tags = params[:brand].delete(:tags) || []
    categories= params[:brand].delete(:categories) || []
    
    # 创建brand
    @brand = Brand.new params[:brand]
    tags.each do |k, v|
      @brand.tagged_brands.build :tag_id => k.to_i
    end
  
    categories.each do |k, v|
      @brand.brands_production_categories.build :production_category_id => k.to_i
    end

    if @brand.save
      flash[:notice] = '品牌添加成功'
      @tag = (@brand.tags_for.size > 0 && @brand.tags_for.first || nil) unless @tag
      redirect_to (@tag ? edit_admin_brand_path(@brand, :tag_id => @tag.TAGID) : edit_admin_brand_path(@brand))
    else
      flash[:alert] = "品牌添加失败 #{@brand.errors.full_messages.join(',')}"
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
    last_tag_id = tags.first[0] unless tags.blank?
    @brand.update_tags(tags.map { |k, v| k.to_i })

    categories = params[:brand].delete(:categories) || []
    last_category_id = categories.first[0] unless categories.blank?
    @brand.update_categories(categories.map { |k, v| k.to_i })

    # 更新其它信息
    @brand.attributes = params[:brand]
    if @brand.save
      flash[:notice] = '品牌更新成功'
      url = edit_admin_brand_path(@brand)
    else
      flash[:alert] = "品牌添加失败 #{@brand.errors.full_messages.join(',')}"
      url = manage_admin_brand_path(@brand)
    end
    redirect_to url
  end
  
  # params[:tag_id] 品类编号
  # return Brand_detail  品牌和品类详细信息
  def detail
    tagged_brands = @tagged_brand
    @tag_id = @tag.TAGID
    if @tag_id.blank?
      head 403
    else
      @brand_logo =  @brand.logos.first(:conditions => ["tag_id = ?", @tag_id])
      @brand_detail = @brand.detail_for @tag_id
    end
  end
  
  def update_detail
    @tag_id = @tag.TAGID
    @brand_detail = @brand.detail_for(@tag_id)
    @brand_detail.update_attributes params[:brand_detail]
    @brand_logo = @brand.logos.first(:conditions => ["tag_id = ?", @tag_id])

    # 更新品牌LOGO图片
    unless (logo = params[:logo]).blank?
      @brand_logo.destroy if @brand_logo
      @brand.logos << BrandPicture.new(
        :uploaded_data => logo,
        :brand_id => @brand.id,
        :tag_id => @tag_id
      )
    end

    if @brand.save
      flash[:notice] = '品牌详细信息已更新'
    else
      flash[:alert] = "品牌详细信息更新失败 #{@brand.errors.full_messages.join(',') }"
    end
    redirect_to :back
  end

  def destroy
    Brand.destroy params[:id]
    flash[:notice] = '品牌已删除'
    redirect_to admin_brands_path
  end

  # 品牌 品类 上线
  def display_category
    change_category_online true 
  end

  # 品牌 品类 下线
  def hide_category
    change_category_online false 
  end

  def change_category_online(visible)
    brand_category = BrandsProductionCategory.find_by_id params[:brand_category_id]
    brand_category.update_attribute :online, !visible
    brand_manage_page(brand_category.brand)
  end

  def display
    change_visibility true
  end

  def hide
    change_visibility false
  end

  def change_visibility(visible)
    brand = Brand.find_by_id params[:id]
    if brand.update_attribute :is_hidden, !visible
      flash[:notice] = '品牌状态已改变'
    else
      flash[:alert] = '品牌状态改变失败'
    end

    brand_manage_page(brand) 
  end
  
  # 重定向到品牌管理页面去
  def brand_manage_page(brand)
    # goto_admin_redirection_addresses_path(:url => current_url) 
    url = request.env["HTTP_REFERER"].to_s
    url = manage_admin_brand_path(brand) if url.blank?
    redirect_to url
  end

  # GET/POST /admin/brands/:id/rating
  # 显示、编辑品牌的口碑评价信息
  def rating
    @tag_id = @tag.TAGID 
    @brand_rating = @brand.rating_for(@tag_id)
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
      BbsTag.create(:name => brand.name_zh, :parent_id => parent_bbs_tag.id, :brand_tag_id => tag_id, 
        :brand_id => brand_id, :priority => brand.priority)
      flash[:notice] = "已为品牌【#{brand.name_zh}】开通了论坛板块"
    rescue Exception => e
      flash[:alert] = "操作失败：#{e}"
    end

    #填充首字母
    BbsTag.find(:all, :select=>"id, name", :conditions=>["brand_id is not null and initial is null"]).each do |tag|
      name_initial = tag.name.mb_chars.first.to_s
      initial = ChineseDictionary.pinyin_for(name_initial)
      name_initial = initial.mb_chars.first.to_s unless initial.nil?
      tag.initial = name_initial.upcase
      tag.save
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
    else
      flash[:alert] = "购买意向修改失败"
    end
    redirect_to rating_admin_brand_path(tagged_brand.brand, :tag_id => tagged_brand.tag_id)
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

  def search_brands_by_name
    respond_to do |format|
      format.json { render :json => Brand.with_name_zh(params[:brand_name]) }
    end
  end
  
  # admin_brand_index
  def manage; end

  # SEO编辑页面
  def html_meta
    @brand_url = show_pinpai_url @brand.permalink, :subdomain => @tag.TAGURL
    @htmlmetadata = HtmlMetadata.find_by_url(@brand_url) || HtmlMetadata.new 
  end

  # 修改SEO数据信息
  def update_html_meta
    # 更新对应品牌页面的属性
    params[:html_metadata][:url] = params[:html_url] unless params[:html_url].blank?
    htmlmetadata = HtmlMetadata.find_by_url params[:html_metadata][:url]
    unless htmlmetadata.blank?
      #htmlmetadata.update_attributes params[:html_metadata]
      ActiveRecord::Base.connection.update_sql("UPDATE 51hejia.html_metadata SET title = '#{params[:html_metadata][:title]}', keywords = '#{params[:html_metadata][:keywords]}', description = '#{params[:html_metadata][:description]}' WHERE url = '#{params[:html_metadata][:url]}'")

      #htmlmetadata.save
      flash[:notice] = "修改SEO信息成功!"
    else
      htmlmetadata = HtmlMetadata.new
      htmlmetadata.url = params[:html_metadata][:url]
      htmlmetadata.title = params[:html_metadata][:title]
      htmlmetadata.keywords = params[:html_metadata][:keywords]
      htmlmetadata.description = params[:html_metadata][:description]
      htmlmetadata.save
      flash[:notice] = "创建SEO信息成功!"
    end
    redirect_to html_meta_admin_brand_path(@brand, :tag_id => @tag.TAGID)
  end

  # 编辑模板信息
  def template
    if request.post?
      unless params[:brand_template].blank?
        #更新品牌的模板
        @tagged_brand.update_attribute(:template, params[:brand_template])
      end
    end
  end
 
  # 品牌推广列表页
  def promotion_pages
    @promotion_pages = TaggedBrandPage.all
  end

  # 新建 || 编辑 推广页
  def promotion_page
    @promotion_page = PromotionPage.find_by_id(params[:id]) || PromotionPage.new  
  end

  # 创建推广页 
  def create_promotion_page
    unless params[:promotion_page][:name].blank?
      promotion_page = PromotionPage.find_by_name(params[:promotion_page][:name]) || params[:promotion_page][:type].classify.constantize.new
      promotion_page.name = params[:promotion_page][:name]
      promotion_page.description = params[:promotion_page][:description]
      if promotion_page.save
        flash[:notice] = "创建品牌推广页面成功!"
      else
        flash[:alert] = "新建品牌推广页面失败!"
      end
    else
      flash[:alert] = "[请输入页面位置]新建品牌推广位失败!"
    end
    redirect_to promotion_page_admin_brand_path(@brand, :tag_id => @tag.TAGID)
  end

  # 修改推广页
  def update_promotion_page
    @promotion_page = PromotionPage.find_by_id(params[:page_id])
    if @promotion_page.update_attributes(params[:promotion_page])
      flash[:notice] = "修改推广页信息成功!"
    else
      flash[:alert] = "修改推广页信息失败!"
    end
    redirect_to :back 
  end
 
  # 具体推广页面的推广项显示
  def promotion_collections_page
    @promotion_page = PromotionPage.find_by_id params[:page_id]
    @promotion_page.create_promotion_item(@promotion_page.name, @tag, @brand) if @tag && @brand
  end
  
  # 编辑品牌印象信息
  def impressions
    if request.post?
      unless @tagged_brand.blank? 
        attributes = params[:attributes]
        values = params[:values]
        attributes.each do |key, name|
          unless name.blank?
            Impression.create({:tagged_brand_id => @tagged_brand.id, :title => name, :number => values[key].to_i}) unless name.blank?
          end
        end
      end
    end
  end
  
end
