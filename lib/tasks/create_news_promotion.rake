namespace :brands do
  desc "专题新闻添加推广信息 "
  task :create_new_promotions =>:environment  do
    unless (date = ENV["date"]).blank?
      if date.length == 6
        items = {
          '题图' => 1,
          '大焦点图' => 3,
          '大焦点图下方文字' => 1,
          '焦点文章' => 5,
          '关注排行榜' => 6,
          '小焦点图' => 3,
          '新品速递' => 0,
          '更多推荐1' => 1,
          '对话参展商' => 6,
          '更多参展商信息' => 6,
          '更多推荐2' => 1,
          '媒体看展台' => 6,
          '更多媒体信息' => 6,
          '现场图集' => 20
        }
        items.keys.each do |key|
          code = "专题:行业新闻:#{date}:" + key
          size = items[key].to_i == 0 ? nil : items[key].to_i 
          PromotionCollection.create!({:name => code.split(":").to_s, :code => code, :item_type => "GeneralResource", :size => size, :remark => key}) 
        end
        puts "Add PormotionCollections aready. Thanks"
      else
        puts "[Format error] Please run rake brands:create_new_promotions date=201106"
      end
    else
      puts "Please run rake brands:create_new_promotions date=201106"
    end
  end
end
