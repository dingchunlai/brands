class Admin::ProductionsController < AdminController

  def index
    tag_id = params[:tagid].to_i
    brand_ids = []
    cd1, cd2 = [], []
    
    unless params[:name].blank?
      cd1 << "name like ?"
      cd2 << "%#{params[:name]}%"
    end

    unless params[:brand_name].blank?
      brand_id = Brand.brand_id_by_name(params[:brand_name])
      if brand_id == 0
        cd1 = ["false"]
      else
        cd1 << "brand_id = ?"
        cd2 << brand_id
      end
    end

    if tag_id > 0
      brand_ids = Brand.of_tag(tag_id,false,"product_brands.id").map{|r| r.id}
      if brand_ids.length == 0
        cd1 = ["false"]
      else
        cd1 << "brand_id in (?)"
        cd2 << brand_ids
      end
    end
    
    @productions = Production.paginate :conditions => [cd1.join(" and ")].concat(cd2),
      :include => [:brand, :category, :series],
      :page => page
  end

  def new
    @production = Production.new
  end

  def create
    @production = Production.new params[:production]
    if properties = params[:properties]
      properties.each do |attr_id, value|
        @production.properties.build :attribute_id => attr_id, :value => value unless value.blank?
      end
    end

    if @production.save
      flash[:notice] = '产品添加成功'
      redirect_to admin_production_pictures_path(@production)
    else
      flash[:alert] = '产品添加失败'
      render :action => :new
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

    @production.attributes = params[:production]

    if @production.save
      flash[:notice] = '产品修改成功'
      redirect_to admin_productions_path
    else
      flash[:alert] = '产品修改失败'
      render :action => :new
    end
  end

  def destroy
    Production.destroy params[:id]
    redirect_to :action => :index
  end

  #产品上架，下架
  def set_is_valid
    id = params[:id].to_i
    Production.update_all("is_valid = 1 - is_valid", ["id = ?", id]) if id > 0
    url = request.env["HTTP_REFERER"].to_s
    url = "/admin/productions" if url.blank?
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
    url = request.env["HTTP_REFERER"].to_s
    url = "/admin/productions" if url.blank?
    redirect_to url
  end

end
