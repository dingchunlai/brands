# encoding: utf-8

desc "百度地图城市编码MAPPING"
task :baidu_city_mapping=>:environment do
  require 'uri'
  require 'yajl/http_stream'
  #gem 'rack' , '1.0.1'
  #require 'rack/utils'
  require 'typhoeus'
  require 'iconv' 

  url = "http://map.baidu.com/?newmap=1&qt=s&wd=%E5%B8%82&c=1&src=0&wd2=&sug=0&l=4&b=(3348905.960000001,2581076.75;19831209.96,6398548.75)&tn=B_NORMAL_MAP&ie=utf-8&t=1293782861082"
  json = Typhoeus::Request.get(url).body
  json_u = Iconv.conv("UTF-8","GBK",json)
  parser = Yajl::Parser.new
  hash = parser.parse(json_u)
  baidu_cities = Array.new
 # hash.each do |h|
  #  p h["name"]
  #end
  hash["content"].each do |hot|
    #baidu_cities << {:name => hot["name"], :code => hot["code"]}
    city_code = $redis.hset "baidu_map_city_code_mapping" , hot["name"],  hot["code"]
  end
  

  hash["more_city"].each do |cities|
    cities.each do |city|
      if city[0] == "city"
        city[1].each do |city_name|
         #  baidu_cities << {:name => city_name["name"], :code => city_name["code"]}
         city_code = $redis.hset "baidu_map_city_code_mapping" , city_name["name"],  city_name["code"]
        end
      end
    end
  end


  
end

desc "百度地图城市编码 测试"
task :baidu_city_mapping_test=>:environment do
 p $redis.hget "baidu_map_city_code_mapping" , "上海市"
end
