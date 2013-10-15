module CityCode
  def current_city_code
    @subdomain = request.subdomains.to_s
    if @subdomain.include?("shanghai")
      @city_code = 'UA-12518263-1'
      @user_city_code = '11910'
    elsif @subdomain.include?("suzhou")
      @city_code = 'UA-12518279-2'
      @user_city_code = '12117'
    elsif @subdomain.include?("ningbo")
      @city_code = 'UA-12518326-3'
      @user_city_code = '12301'
    elsif @subdomain.include?("hangzhou")
      @city_code = 'UA-12518326-2'
      @user_city_code = '12306'
    elsif @subdomain.include?("wuxi")
      @city_code = 'UA-12518279-3'
      @user_city_code = '12118'
    elsif @subdomain.include?("wuhan")
      @user_city_code = '12093'
    elsif @subdomain.include?("nanjing")
      @user_city_code = '12122'
    elsif @subdomain.include?("qingdao")
      @user_city_code = '12173'
    elsif @subdomain.include?("changsha")
      @user_city_code = '12109'
    elsif @subdomain.include?("hefei")
      @user_city_code = '11921'
    elsif @subdomain.include?("zhengzhou")
      @user_city_code = '12059'
    elsif @subdomain.include?("beijing")
      @user_city_code = '11905'
    elsif @subdomain.include?("guangzhou")
      @user_city_code = '31959'
    elsif @subdomain.include?("shenzhen")
      @user_city_code = '11971'
    elsif @subdomain.include?("haikou")
      @user_city_code = '12013'
    elsif @subdomain.include?("xiamen")
      @user_city_code = '11944'
    elsif @subdomain.include?("chengdu")
      @user_city_code = '12243'
    elsif @subdomain.include?("chongqing")
      @user_city_code = '11908'
    elsif @subdomain.include?("tianjin")
      @user_city_code = '11887'
    elsif @subdomain.include?("changchun")
      @user_city_code = '12349'
    elsif @subdomain.include?("dalian")
      @user_city_code = '12142'
    elsif @subdomain.include?("haerbin")
      @user_city_code = '12069'
    elsif @subdomain.include?("kunming")
      @user_city_code = '12288'
    elsif @subdomain.include?("shijiazhuang")
      @user_city_code = '12030'
    elsif @subdomain.include?("taiyuan")
      @user_city_code = '12194'
    elsif @subdomain.include?("xian")
      @user_city_code = '12208'
    #PLACE_HOLDER
    else
      #      @city_code = 'UA-12518263-1'
      #      @user_city_code = '11910'
    end
    cookies[:user_city] = {:value => @user_city_code, :domain=>".51hejia.com",:expires => 1.years.from_now}
  end
end
