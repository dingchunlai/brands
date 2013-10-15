class Admin::AgenciesController < AdminController

  before_filter :tags, :only => [:new, :edit]

  def index
    agency = Agency
    agency = agency.with_title(params[:title]) unless params[:title].blank?
    @agencies = agency.paginate :page => params[:page], :per_page => 15, :order => "updated_at DESC" 
  end

  def new
    @agency = Agency.new
    render :action => :edit
  end

  def edit
    @agency = Agency.find params[:id]
    @tagged_brand = TaggedBrand.find_by_id @agency.tagged_brand_id
    @brands = Brand.of_tag(@tagged_brand.tag.TAGID)
  end

  def create
    tagged_brand = TaggedBrand.find_by_tag_id_and_brand_id(params["brand_category_id"], params["brand_id"])
    unless tagged_brand.blank?
      params[:agency][:tagged_brand_id] = tagged_brand.id
      agency = Agency.new(params[:agency])
      agency.save
      flash[:notice] = "创建成功 !"
    else
      flash[:alert] = "创建失败 !"
    end
    redirect_to :action => :new
  end

  def update
    agency = Agency.find params[:id]
    tagged_brand  = TaggedBrand.find_by_tag_id_and_brand_id(params["brand_category_id"], params["brand_id"])
    unless tagged_brand.blank?
      params[:agency][:tagged_brand_id] = tagged_brand.id
      agency.update_attributes params[:agency]
      flash[:notice] = "修改成功 !"
    else
      flash[:alert] = "修改失败 !"
    end
    redirect_to :back
  end

  def destroy
    flash[:notice] = '删除成功 !'
    Agency.destroy params[:id]
    redirect_to :back
  end

  def tags
    tagged_brand = TaggedBrand.find_by_sql("select distinct tag_id from tagged_brands")
    @tags = []
    tagged_brand.each do |tag|
      t = Tag.categories.find_by_TAGID tag.tag_id
      @tags << t unless t.blank?
    end
  end
  private :tags
end
