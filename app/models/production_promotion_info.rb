class ProductionPromotionInfo < ActiveRecord::Base

  set_table_name "production_promotion_info"
   
  belongs_to :production

  class << self

    #取得“品类首页”产品推广记录
    def get_production_promotions(limit, priority_type, brand_category_id=0, brand_id=0,c_id=nil)
      rs = Production.get_production_by_promotion_info(limit, priority_type, brand_category_id, brand_id,c_id)
      if rs.length < limit
        conditions = ["is_valid = 1"]
        conditions << "brand_category_id = #{brand_category_id}" if brand_category_id.to_i > 0
        conditions << "brand_id = #{brand_id}" if brand_id.to_i > 0
        conditions << "id not in (?)" if rs.length > 0
        rs2 = Production.find(:all, :conditions=> [conditions.join(" and "), rs.map{ |r| r.id}], :limit => limit-rs.length, :include => [:master_picture, :brand], :order => 'id desc')
        rs = rs.concat(rs2)
      end
      rs
    end


  end
  
end
