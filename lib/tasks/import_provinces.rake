namespace :coupon do
  desc "Initialize: import province data."
  task :import_province  => :environment do
    @provinces = {"liaoning"=>"辽宁", "qinghai"=>"青海", "gansu"=>"甘肃", "yunnan"=>"云南", "hainan"=>"海南", "chongqing"=>"重庆", "hunan"=>"湖南", "hubei"=>"湖北", "jiangxi"=>"江西", "shanghai"=>"上海", "neimeng"=>"内蒙", "shandong"=>"山东", "guizhou"=>"贵州", "quanguo"=>"全国", "guangxi"=>"广西", "fujian"=>"福建", "shanxi1"=>"山西", "henan"=>"河南", "zhejiang"=>"浙江", "anhui"=>"安徽", "beijing"=>"北京", "xinjiang"=>"新疆", "ningxia"=>"宁夏", "jiangsu"=>"江苏", "jilin"=>"吉林", "hebei"=>"河北", "guangdong"=>"广东", "sichuan"=>"四川", "heilongjiang"=>"黑龙江", "shanxi"=>"陕西"}
    unless Province.count > 0
      keys = @provinces.keys.sort
      keys.delete "quanguo"
      keys.each do |key|
        Province.create!(:name => @provinces[key], :pinyin => key, :code_name => key)
      end
    end
  end
  
end