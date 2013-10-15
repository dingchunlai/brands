class ProductionCategoriesController < ApplicationController
  # 取得某个产品类别的技术参数
  def attrs
    respond_to do |format|
      format.json { render :json => ProductionCategory.find(params[:id]).attrs }
    end
  end

  def for_tag_and_brand
    #for_tag_and_brand_categories_path
    tag_id , brand_id = params[:tag_id].to_i, params[:brand_id].to_i
    return render :json => [] if tag_id == 0 || brand_id == 0
    production_categories = ProductionCategory.for_tag(tag_id).for_brand(brand_id).map{ |pc| [pc.name, pc.id]}
    render :json => production_categories
  end

end
