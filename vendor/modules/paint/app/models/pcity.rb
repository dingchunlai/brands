class Pcity < Hejia::Db::Hejia
  def self.pinyin chinese
    ChineseDictionary.pinyin_for chinese
  end
  
  def self.add_all
#    City.set_province_for 'hangzhou', 'zhejiang'
#    City.add("hangzhou","杭州")
    provinces = Pcity.find(:all, :select => "distinct(province)")
    provinces.each do |p|
      Province.add(Pcity.pinyin(p.province), p.province)
    end
    pcites = Pcity.find(:all)
    pcites.each do |p|
      City.add(Pcity.pinyin(p.city), p.city)
      City.set_province_for(Pcity.pinyin(p.city), Pcity.pinyin(p.province))
    end
  end
end
