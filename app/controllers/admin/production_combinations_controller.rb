# 组合案例管理controller
# 主要功能组合案例添加，修改，删除
# 关系对象Brand品牌对象,Tag品类对象
class Admin::ProductionCombinationsController < AdminController
  before_filter  :load_tags       # 拿出所有属于品牌库的品类对象来
  
  # @params[:title]  组合案例标题  String
  # @params[:brand]  组合案例关联的品牌名  String
  # @params[:tag]    组合案例关联的品类名  String
  # @combinations    组合案例集合
  def index
    combinations = ProductionCombination
    unless params[:brand_name].blank?
      brand_mame =  Brand.find(:first, :conditions => ["name_zh = ?",params[:brand_name]])
      combinations =  combinations.with_brand(brand_mame)  if brand_mame
    end
    unless params[:tag_name].blank?
      tag_name =  Tag.categories.first :conditions => ["TAGNAME = ?",params[:tag_name]]
      combinations =  combinations.with_tag(tag_name.TAGID)  if tag_name
    end
    combinations = combinations.with_title(params[:title]) unless params[:title].blank?
    @combinations = combinations.paginate :include => [:brand, :tag, :master_picture], :page => page
  end
  # 进入添加组合案例页面携带params[:combination]对象
  def new
    @combination = ProductionCombination.new
  end
  # 新建页面的创建方法
  # @params[:combination] 一个包含组合案例多属性的一个对象  ProductionCombination
  def create
    @combination = ProductionCombination.new params[:combination]
    if @combination.save
      flash[:notice] = '组合案例添加成功'
      redirect_to admin_production_combination_combination_pictures_path(@combination)
    else
      flash[:alert] = '组合案例添加失败'
      render :action => :new
    end
  end
  # 管理页面点击编辑后的实现方法，最后进入编辑页面
  # params[:id] 组合案例的主键 Integer
  def edit
    @combination = ProductionCombination.find params[:id]
    @brand_tags = Tag.first :conditions => ['TAGID = ?', @combination.tag_id]
    render :action => :new
  end
  # 组合案例编辑页面的修改方法
  # @params[:combination] 包含组合案例所有属性的一个对象   ProductionCombination
  def update
    @combination = ProductionCombination.find params[:id]
    if @combination.update_attributes params[:combination]
      flash[:notice] = '组合案例修改成功'
      redirect_to :action => :index
    else
      flash[:alert] = '组合案例修改失败'
      render :action => :new
    end
  end
  # 组合案例管理页面的删除方法
  # @params[:id]  组合案例的主键编号   Integer
  def destroy
    ProductionCombination.destroy params[:id]
    flash[:notice] = '组合案例已被删除'
    redirect_to :action => :index
  end
  # 前置过滤器，用于将所有的品牌库下的品类对象全部拿出来
  private
  def load_tags
    @tags = Tag.categories
  end
end
