# -tencoding uft-8
class Admin::PromotionPagesController < AdminController
  # admin.resources :promotion_pages,  :member => {:items => :get, :search_item => :get, :add_item => :post, :edit_item => :post} 

  before_filter :must_be_admin, :except => [:index, :search_item]
  
  # ----Promotion_page_start
  def index
    @promotion_pages = PromotionPage.all
  end

  def new
    @promotion_page = PromotionPage.new
  end

  def create
    promotion_page = params[:promotion_page][:type].classify.constantize.new
    promotion_page.name = params[:promotion_page][:name]
    promotion_page.description = params[:promotion_page][:description]
    if promotion_page.save
      flash[:notice] = '创建成功 !'
    else
      flash[:alert] = "创建失败 !"
    end
    redirect_to :action => :new 
  end

  def edit
    @promotion_page = PromotionPage.find params[:id]
    render :action => :new
  end

  def update
    promotion_page = PromotionPage.find params[:id]
    model_name = "#{promotion_page.class.name.tableize.singularize}"
    promotion_page.update_attributes(params[model_name])
    flash[:notice] = '修改成功 !'
    redirect_to :action => :index
  end

  def destroy
    PromotionPage.destroy params[:id]
    flash[:notice] = '删除成功 !'
    redirect_to :back
  end
  # ----promotion_page_end

  #  ---------------关于推广项的管理-----------------
  # 某页面推广项管理页面
  def items
    @promotion_page = PromotionPage.find params[:id]
    @promotion_page_part = params[:item_id] ? PromotionPagePart.find_by_id(params[:item_id]) : PromotionPagePart.new
  end
  
  # 添加某页面的推广项
  def add_item
    promotion_page = PromotionPage.find params[:page_id]
    params[:promotion_page_part][:page] = promotion_page
    promotion_page_part = PromotionPagePart.new(params[:promotion_page_part])
    if promotion_page_part.save
      flash[:notice] = "创建成功 !"
    else
      flash[:alert] = "创建失败 !"
    end
    redirect_to :action => :items
  end
  
  # 编辑某页面推广项信息
  # 当选择某个页面时 编辑属于某个页面中的推广项
  def edit_item
    promotion_page_part = PromotionPagePart.find(params[:item_id])
    promotion_page_part.update_attributes(params[:promotion_page_part])
    flash[:notice] = "修改成功 !"
    redirect_to :action => :items, :item_id => promotion_page_part.id
  end 

  # 推广信息检索管理页面
  # 当选择某品类或者品牌时：有则查询出来，无则创建
  def search_item
    @tag = Tag.find_by_TAGID(params[:tag_id]) unless params[:tag_id].blank?
    @brand = Brand.find_by_id(params[:brand_id]) unless params[:brand_id].blank?
    @brands = Brand.for_tag(@tag.TAGID, true, "product_brands.id, product_brands.name_zh") unless @tag.blank?
    @promotion_page = PromotionPage.find params[:id]
    if @promotion_page.is_a?(TaggedBrandPage)
      @promotion_page.create_promotion_item(@promotion_page.name, @tag, @brand) if @tag && @brand
    elsif @promotion_page.is_a?(TagPage)
      @promotion_page.create_promotion_item(@promotion_page.name, @tag) if @tag
    end
=begin
    unless @tag.blank?
      if @brand.nil?
        @promotion_page.create_promotion_item(@promotion_page.name, @tag)
      else
        @promotion_page.create_promotion_item(@promotion_page.name, @tag, @brand)
      end
    end
=end
  end
 
  # 修改现有数据中的错误CODE值
  def modify
    promotion_page = PromotionPage.find_by_id params[:id]
    promotion_collections = PromotionCollection.find_by_sql("select * from promotion_collections where code like '%#{promotion_page.name}%'")
    promotion_collections && promotion_collections.each do |item|
      code_items =item.code.split(":")
      tag = Tag.categories.find_by_TAGURL code_items[2]
      brand = Brand.find_by_permalink code_items[3]
      item_name = code_items[4]
      code = promotion_page.item_code(promotion_page.name, tag.TAGURL, brand.permalink, item_name)
      name = promotion_page.item_code(promotion_page.name, tag.TAGNAME, brand.name_zh, item_name).gsub(':', '')
      item.update_attributes({:code => code, :name => name})
    end
    flash[:notice] = "修改了#{promotion_collections.size}条数据"
    redirect_to :action => :index
  end
 
  # 验证是否是admin用户
  def must_be_admin
    unless staff_logged_in? && session[:is_hejia_admin]
      redirect_to :action => :index
    end
  end
  private :must_be_admin

end
