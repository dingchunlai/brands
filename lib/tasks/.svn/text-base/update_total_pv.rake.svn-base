desc 'update used_tags pv by brand'


## 得到所有已启用品类
## 得到某品类所有已上线的品牌

task :increase_pv_number => :environment do
  p "increase_pv_number star..."
  now = Time.now
  for tag in Tag.used_categories
    for brand in Brand.of_tag(tag.TAGID, false)
      tmp_pv = Brand::increase_pv_number(brand,tag,now.hour,now.min)
      $redis.hincrby "brands:#{brand.id}:pv:#{tag.id}", "total", tmp_pv.to_i
      $redis.hincrby "brands:#{brand.id}:pv:#{tag.id}", Time.now.strftime('%Y%m'), tmp_pv.to_i
      $redis.zincrby "brands:pv:#{tag.id}:total", tmp_pv.to_i, brand.id
    end
  end
  p "increase_pv_number end..."
end