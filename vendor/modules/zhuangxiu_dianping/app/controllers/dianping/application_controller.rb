class Dianping::ApplicationController < ApplicationController
  include CityCode
  
  helper :all
  skip_before_filter :get_promotion_items_for_layout, :brand_validation_filter
  before_filter :current_city_code
  

  # 验证公司是否与用户访问的子域名相符。
  # 如：苏州的公司，访问的子域名应该是suzhou.51hejia.com。
  # 主要提供给before_filter使用。
  # @param [Symbol] id_param_name 公司id的参数名称，默认为:id
  # @yield [DecoFirm] 如果验证失败，则执行block，参数为当前访问的公司
  # @return [DecoFirm] 返回公司对象
  def validates_firm_with_subdomain(id_param_name = :id)
    firm = DecoFirm.find params[id_param_name]

    if firm
      #判断域名和公司是否匹配
      subdomain = request.subdomains.to_s

      if firm.city == 11910 && !subdomain.include?("shanghai")
        yield firm
      elsif firm.city == 11905 && !subdomain.include?("beijing")
        yield firm
      elsif firm.city == 31959 && !subdomain.include?("guangzhou")
        yield firm
      elsif firm.city == 11908 && !subdomain.include?("chongqing")
        yield firm
      elsif firm.city == 11887 && !subdomain.include?("tianjin")
        yield firm
      elsif [11910, 11905, 31959,11908,11887].index(firm.city).nil?#firm.city != 11910
        if (city_subdomain = TAGURLS[firm.district]).blank?
          page_not_found!
        elsif !subdomain.include?(city_subdomain)
          yield firm
        end
      end
    else # firm is nil
      page_not_found!
    end

    firm
  end
  protected :validates_firm_with_subdomain

  #公司终端页与公司下面的各个公司下的列表页
  def validates_dianping_with_subdomain(id = params[:id], firm_id = params[:firm_id])
    @firm = DecoFirm.find(firm_id.blank? ? id : firm_id)
    if @firm
      pinyin = @firm.city_pinyin
      current_url = request.url
      unless current_url.include?(pinyin)
        url = request.url.gsub(/shanghai|wuxi|suzhou|hangzhou|ningbo|wuhan|nanjing|qingdao|changsha|hefei|zhengzhou|beijing|guangzhou|shenzhen|haikou|xiamen|chengdu|chongqing|tianjin|changchun|dalian|haerbin|kunming|shijiazhuang|taiyuan|xian/,pinyin)
        redirect_301_to url
      end
    else
      page_not_found!
    end
  end
  protected :validates_dianping_with_subdomain

  #各个终端页
  def vaildates_dianping_zhongduan_with_subdomain(id = params[:id])
    current_url = request.url
    someth = case
    when current_url.include?("stories") ; DecorationDiary.find(id)
    when current_url.include?("cases") ; HejiaCase.find(id)
    when current_url.include?("designers") ; CaseDesigner.find(id)
    when current_url.include?("ideas") ; DecoIdea.find(id)
    when current_url.include?("services") ; DecoService.find(id)
    when current_url.include?("vouchers") ; DecoEvent.find(id)
    when current_url.include?("coupons") ; Coupon.find(id)
    when current_url.include?("decoration_diaries") ; DecorationDiary.find(id)
    end
    if someth
      if current_url.include?("coupons")
        pinyin = TAGURLS[CITIES.index(COUPON_CITIES[someth.city_id])]
      elsif current_url.include?("vouchers")
        pinyin = someth.firms.first.city_pinyin
      else
        pinyin = someth.deco_firm.city_pinyin
      end
      unless current_url.include?(pinyin)
        url = request.url.gsub(/shanghai|wuxi|suzhou|hangzhou|ningbo|wuhan|nanjing|qingdao|changsha|hefei|zhengzhou|beijing|guangzhou|shenzhen|haikou|xiamen|chengdu|chongqing|tianjin|changchun|dalian|haerbin|kunming|shijiazhuang|taiyuan|xian/,pinyin)
        redirect_301_to url
      end
    else
      page_not_found!
    end

  end
  protected :vaildates_dianping_zhongduan_with_subdomain
 
end
