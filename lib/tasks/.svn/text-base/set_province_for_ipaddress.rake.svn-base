desc "为IP库添加省份"
task :set_province_for_ipaddress =>:environment  do
    p "add ip........."
    p "star..."
    address = IpAdd.find(:all,:conditions => "ip_area like '%省%'");
    address.each do |d|
      province = d.ip_area.split('省')
      pinyin = Province.pinyin(province[0])
      IpAdd.update_all("province = '#{pinyin}'","ipstart = #{d.ipstart}")
    end
    p "end..."
    
end