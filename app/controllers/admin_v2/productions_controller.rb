class AdminV2::ProductionsController < AdminV2Controller
  
  before_filter :validate_tagged_brand, :except => [:save_promotion_info, :set_is_valid]

  def index
    productions = Production
    productions = productions.of_brand_tag(@brand.id, @tag.id)
    @productions = productions.paginate :include => [:brand, :category, :series],
      :page => page
  end

  def new
    @production = Production.new
  end

  def create
    params[:production][:brand_category_id] = params[:tag_id]
    params[:production][:brand_id] = params[:brand_id]
    @production = Production.new params[:production]
    if properties = params[:properties]
      properties.each do |attr_id, value|
        @production.properties.build :attribute_id => attr_id, :value => value unless value.blank?
      end
    end

    if @production.save
      flash[:notice] = '产品添加成功'
      redirect_to admin_production_pictures_path(@production, :brand_id => @brand.id, :tag_id => @tag.TAGID)
    else
      flash[:alert] = '产品添加失败'
      redirect_to new_admin_brand_production(@brand, :tag_id => @tag.TAGID)
    end
  end

  def edit
    @production = Production.find params[:id], :include => [
      {:category => [:attrs]},
      {:brand    => [:production_series]},
      :properties
    ]
    @brand_tag = Tag.first :conditions => ['TAGID = ?', @production.brand_category_id]
    render :action => :new
  end

  def update
    @production = Production.find params[:id], :include => :properties

    # update properties
    properties = (params[:properties] || {}).inject({}) do |h, (k, v)|
      h[k.to_i] = v unless v.blank?
      h
    end
    @production.properties.each do |p|
      if v = properties.delete(p.attribute_id)
        p.update_attribute :value, v
      else
        p.destroy
      end
    end
    properties.each do |attr_id, value|
      @production.properties.build :attribute_id => attr_id, :value => value
    end
    # end update properties

    @production.attributes = params[:production].update(:updated_at => Time.now)

    if @production.save
      flash[:notice] = '产品修改成功'
    else
      flash[:alert] = '产品修改失败'
    end
    redirect_to edit_admin_brand_production_path(@brand, @production.id, :tag_id => @tag.TAGID)
  end

  def destroy
    Production.destroy params[:id]
    redirect_productions_index
  end

  #产品上架，下架
  def set_is_valid
    id = params[:id].to_i
    Production.update_all("is_valid = 1 - is_valid", ["id = ?", id]) if id > 0
    redirect_productions_index
  end

  # redirect "HTTP_REFERER" :back
  def redirect_productions_index
    url = request.env["HTTP_REFERER"].to_s
    url = admin_brand_productions_path(@brand, :tag_id => @tag.TAGID) if url.blank?
    redirect_to url
  end

  #保存产品推广信息
  def save_promotion_info
    p_id, shouye_index, pinlei_index, pinpai_index = params[:id].to_i, params[:shouye_index].to_i, params[:pinlei_index].to_i, params[:pinpai_index].to_i
    if p_id > 0 && (shouye_index+pinlei_index+pinpai_index) > 0
      prod = ProductionPromotionInfo.find_by_production_id(p_id)
      prod = ProductionPromotionInfo.new({:production_id=>p_id}) if prod.nil?
      prod.index_priority = shouye_index
      prod.category_index_priority = pinlei_index
      prod.brand_index_priority = pinpai_index
      prod.save
    elsif p_id > 0
      ProductionPromotionInfo.delete_all(["production_id = ?", p_id])
    end
    redirect_productions_index
  end

end
