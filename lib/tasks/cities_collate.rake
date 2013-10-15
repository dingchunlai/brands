desc "多乐士城市校对"
task :cities_collate =>:environment  do
  xls_cites = []
  File.open('/Users/mao/Documents/cities.csv').each_line{ |s|
    lines = s.split(',')
    xls_cites << lines[0]
  }
  # "\"石狮\"\n"
  xls_cites = xls_cites.map{|city| city.gsub(/[\"\n]/, '') }
  data_ciites = City.get_city_for_model("多乐士").map{ |city| city.name }
  # p data_ciites
  p "数据库中有城市: #{data_ciites.size } 个 "
  # p xls_cites
  p "xls表格中有城市 :  #{xls_cites.size }个 "
  
  cc = xls_cites - data_ciites
  bb = data_ciites - xls_cites
  p " 表格比数据库多的 : xls_cites - data_ciites 为 "
  p cc
  p " 数据库中比表格中多的 :data_ciites - xls_cites 为 "
  p bb
end