class AdminV2::PicturesController < AdminV2Controller
  
  before_filter :find_attachable_object

  def index
    @pictures = @attachable_object.pictures
  end

  def create
    @picture = ProductPicture.new params[:picture]
    @picture.is_master = 1 if @attachable_object.master_picture.nil? # 强制第一张上传的图片是主图
    @picture.attachable = @attachable_object
    if @picture.save
      @picture.resolve_conflict if @picture.master?
      flash[:notice] = '图片添加成功'
    else
      flash[:alter] = '图片添加失败'
    end
    redirect_to :back
  end

  def destroy
    ProductPicture.destroy params[:id]
    flash[:notice] = '图片已被删除'
    redirect_to :back
  end

  def set_master
    @picture = ProductPicture.find params[:id]
    if @picture.master? && @picture.not_master! || @picture.master!
      flash[:notice] = '设置成功'
    else
      flash[:notice] = '设置失败'
    end
    redirect_to :back
  end

  private
  def find_attachable_object
    @attachable_object =
      {
        :production_id => Production,
        :production_combination_id => ProductionCombination
      }.each do |key, model|
        break model.find(params[key]) if params[key]
      end
  end
  
  def find_tagged_brand
    @brand = Brand.find_by_id params[:brand_id] unless params[:brand_id].blank?
    @tag = Tag.categories.find_by_TAGID params[:tag_id] unless params[:tag_id].blank?
  end
  private :find_tagged_brand


end
