class BrandValidationFilter

  # 确保访问正确（行业、品牌存在，并且品牌和行业之间存在关系）
  def self.filter(controller)
    controller.instance_eval do
      @tag = Tag[controller.current_subdomain]
      @brand = Brand.of_tag(@tag).first :conditions => ['permalink = ?', params[:permalink]]
      if @brand
        @tagged_brand = @brand.tagged_brands.find_by_tag_id @tag.id
      else
        head 404
      end
    end
  end

end
