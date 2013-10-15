desc "添加所有省和城市到redis"
task :add_province_and_city =>:environment  do
  
   p "star..."
    provinces = Pcity.find(:all, :select => "distinct(province)")
    provinces.each do |p|
      Province.add(Pcity.pinyin(p.province), p.province)
    end
    pcites = Pcity.find(:all)
    pcites.each do |p|
      City.add(Pcity.pinyin(p.city), p.city)
      City.set_province_for(Pcity.pinyin(p.city), Pcity.pinyin(p.province))
    end
    p "end..."
    
end