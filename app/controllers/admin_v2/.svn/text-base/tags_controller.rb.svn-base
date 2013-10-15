class AdminV2::TagsController < AdminV2Controller

  before_filter :validate_tag, :only => [:manage]
  
  def index
    @tags = Tag.all_categories(params[:name])
=begin
      unless params[:name].blank?
        Tag.categories.all :conditions => ['TAGNAME like ?', "%#{params[:name]}%"]
      else
        Tag.categories
      end
=end
  end

  def update
    tag = Tag.find_category(params[:id])
    if params[:create_bbs] == "1"
      bbs_tag = BbsTag.create(:name => tag.TAGNAME)
      tag.bbs_tag = bbs_tag
      flash[:notice] = "“#{tag.TAGNAME}”的相关论坛板块已开通"
    else
      tag.enabled? ? tag.disable! : tag.enable!
      flash[:notice] = "品类状态改变成功"
    end
    url = request.env["HTTP_REFERER"].to_s
    url = manage_admin_tag_path(tag) if url.blank?
    redirect_to url
  end
  
  def destroy
    tag = Tag.find_category(params[:id])
    tag.delete!
    flash[:notice] = '删除品类成功'
    redirect_to :action => :index
  end

  def tag_brands
    @bbs_tag = BbsTag.find(params[:bbs_tag_id].to_i) if params[:bbs_tag_id].to_i > 0
    @tag_id = params[:id]
    @tag = Tag.find(@tag_id)
    @brands = Brand.of_tag(@tag, true) # 需要包括所有品牌
  end

  #保存论坛板块SEO信息
  def bbs_tag_save
    begin
      bbs_tag = BbsTag.find(params[:bbs_tag_id])
      bbs_tag.attributes = params[:bbs_tag]
      bbs_tag.save
      flash[:notice] = "论坛板块SEO信息保存成功！"
    rescue Exception => e
      flash[:alert] = "操作失败： #{e}"
    end
    redirect_to tag_brands_admin_tag_path(params[:id])+"?bbs_tag_id=#{params[:bbs_tag_id]}"
  end

  def manage
  end
  
  def validate_tag
    @tag = Industry.find_by_TAGID params[:id] unless params[:id].blank?
    unless @tag
      redirect_index("未找见品类")
    end
  end
  private :validate_tag
end
