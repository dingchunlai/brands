module FeaturesHelper

  CITIES_PINYIN = {
    "ningbo" => "宁波" ,"wuxi" => "无锡" , "suzhou" => "苏州", "shanghai" => "上海", "hangzhou" => "杭州"
  }

  def auto_urls city
     a = ""
     $redis.keys("#{city}:*").reverse.each do |data|
       date = data.last(6)
       a.concat "<option value='http://z.#{city}.51hejia.com/features/glory/#{date}.html'>#{CITIES_PINYIN[city]}地区#{date.first(4)}年#{date.last(2)}月排行榜 </option>"
     end
     a
  end
   
  def options_for_month_select city
    case city
      when "ningbo"
      %{
        #{ auto_urls(city) }
        <option value="http://zt.51hejia.com/zhuanti/rybnb05/index.html">宁波地区2010年05月排行榜 </option>
        <option value="http://zt.51hejia.com/zhuanti/rybnb04/index.html">宁波地区2010年04月排行榜 </option>
        <option value="http://zt.51hejia.com/zhuanti/rybnb03/index.html">宁波地区2010年03月排行榜 </option>
        <option value="http://zt.51hejia.com/zhuanti/zhtop/index.html">宁波地区2010年02月排行榜 </option> 
      }
      when "wuxi"
      %{
        #{auto_urls(city)}
        <option value="http://zt.51hejia.com/zhuanti/rybwx06/index.html">无锡地区2010年06月排行榜 </option>
        <option value="http://zt.51hejia.com/zhuanti/rybwx04/index.html">无锡地区2010年04月排行榜 </option>
        <option value="http://www.51hejia.com/zhuanti/rybwx/index.html">无锡地区2010年02月排行榜 </option>
      }
      when "suzhou"
      %{
        #{auto_urls(city)}
        <option value="http://www.51hejia.com/zhuanti/rybsz/index.html">苏州地区2010年02月排行榜 </option>
        <option value="http://www.51hejia.com/zhuanti/rybsz03/index.html">苏州地区2010年03月排行榜 </option>
        <option value="http://www.51hejia.com/zhuanti/rybsz04/index.html">苏州地区2010年04月排行榜 </option>
        <option value="http://zt.51hejia.com/zhuanti/rybsz/index.html">苏州地区2010年05月排行榜 </option>
      }
      else
      %{
        #{auto_urls(city)}
      }
    end #end case
    
  end
  
 
  
end
