namespace :coupon do
  desc 'Synthesis Brand Industry Name IF OPTION[:COUPON_ID] = XXX '
  task :synthesis_brand_industry_name => :environment do

    # 合成品牌和行业的名称 => 抵用卷
    unless ENV['COUPON_ID'].blank?
      coupon = Coupon.find_by_id ENV['COUPON_ID']
      unless coupon.blank?
        coupon.update_attribute :brand_industry_name, (coupon.brand.name_zh + coupon.tag.short_name.gsub("/", "").gsub("／", ''))
      else
        puts "[#{ENV['COUPON_ID']}]此抵用卷编号不存在"
      end
    else
      # 合成品牌和行业的名称 
      Coupon.all.each do |coupon|
        if coupon.brand_industry_name.blank?
          coupon.update_attribute :brand_industry_name, (coupon.brand.name_zh + coupon.tag.short_name.gsub("/", "").gsub("／", '')) 
        end
      end
    end

  end
end
