# encoding: utf-8
# Add For Coupon
class AdminV2Controller < ApplicationController

  layout 'admin_v2'
  
  skip_before_filter :get_promotion_items_for_layout

  before_filter :authenticate

  protected
  
  # 验证后台品牌管理页面是否绑定品类
  def validate_tagged_brand
    @brand = Brand.find_by_id params[:brand_id] unless params[:brand_id].blank?
    @brand = Brand.find_by_id params[:id] if @brand.nil? && params[:id]

    unless @brand.blank?
      unless params[:tag_id].blank?
        @tag = Industry.categories.find_by_TAGID params[:tag_id]
      else
        @tag = @brand.tags_for.size && @brand.tags_for.first.tag || nil 
      end
      unless @tag.blank?
        @tagged_brand = TaggedBrand.find_by_tag_id_and_brand_id @tag.TAGID, @brand.id
        unless @tagged_brand
          redirect_index("[品牌，品类未关联]")
        end
      else
        redirect_index("[品类信息不存在]")
      end
    else
      redirect_index("[品牌信息不存在]")
    end
  end
  private :validate_tagged_brand

  # 返回后台管理首页
  def redirect_index(notice)
    flash[:alert] = "注：#{notice}  请别误操作了 "
    redirect_to admin_index_index_path
  end
  private :redirect_index
  
  # 加载品牌，品类对象 有则有，无则不做任何处理
  def loaded_with_information
   @brand = Brand.find_by_id params[:brand_id] unless params[:brand_id].blank?
   @brand = Brand.find_by_id params[:id] if @brand.nil? && params[:id]

   unless @brand.blank?
     @tag = Industry.categories.find_by_TAGID params[:tag_id] unless params[:tag_id].blank?
     @tag = (@brand.tags_for.size > 0 && @brand.tags_for[0] || nil) unless @tag
     if @tag && @brand
       @tagged_brand = TaggedBrand.find_by_tag_id_and_brand_id @tag.TAGID, @brand.id 
       if @tagged_brand.nil?
         redirect_index("[品牌，品类未关联]")
       end
     end
   end
  end
  private :loaded_with_information

end
