module Dianping::FirmsHelper
  
 

  #专为公司列表页显示的公司名称为12位
  def get_list_firm_name_abbr2 firm
    if firm.name_abbr && firm.name_abbr != ''
      truncate(firm.name_abbr,:length => 12,:omission => '')
    end
  end
  
  
  def store_photo_link(photo, size = "300x180")
    unless photo.link.blank?
      photo.link = "http://#{photo.link}"  if photo.link[0,7] != "http://"
      link_to image_tag(photo.picture.url(size),:alt=>""), photo.link, :target =>"_blank"
    else
      image_tag(photo.picture.url(size),:alt=>"")
    end
  end


  # 为了google 统计，需要改进
  def get_city_name(city)
    HejiaTag
    key = "zhaozhuangxiu_firm_id_page_google_analytics_#{city}_city_name"
    Hejia[:cache].fetch key, 1.hour do
      HejiaTag.find(:first, :select => "TAGNAME", :conditions => "TAGID = #{city}")
    end
     
  end
   
  # 为了google 统计，需要改进
  def get_district_name(district)
    HejiaTag
    key = "zhaozhuangxiu_firm_id_page_google_analytics_#{district}_district_name"
    Hejia[:cache].fetch key, 1.hour do
      HejiaTag.find(:first, :select => "TAGNAME", :conditions => "TAGID = #{district}")
    end
  end

  def firm_remark_mark_verify(user_id)
    $redis.get("remark:mark:user:#{user_id}").nil? ? true : false
  end

  private

  def show_star num
    case num.to_i
    when 2 || 3
      hanzi = "很不满意"
    when 4 || 5
      hanzi = "不满意"
    when 6 || 7
      hanzi = "一般"
    when 8 || 9
      hanzi = "满意"
    when 10
      hanzi = "非常满意"
    end
    width = num.to_i / 2 * 18
    %w{<p style="width:#{width}"></p>}
  end

   
  def show_remark_star city_code,remark
    praise = if remark.praise.to_i > 0
      remark.praise.to_i * 0.8
    elsif remark.praise.to_i <= 0 && remark.decoration_diary && remark.decoration_diary.status == 1 && remark.decoration_diary.praise.to_i >0
      if remark.decoration_diary.is_verified.to_i != 1 && remark.decoration_diary.finished == false
        remark.decoration_diary.praise.to_i * 0.8
      elsif remark.decoration_diary.is_verified.to_i == 1 && remark.decoration_diary.finished == true
        remark.decoration_diary.praise.to_i
      else
        remark.decoration_diary.praise.to_i * 0.9
     end
    else
      0
    end
    #上海去掉4颗半星显示
    if city_code.to_i == 11910 && praise.round >= 9
      "<p style='width:86px'></p>"
    else
      "<p style='width:#{ praise.round.to_f / 2.0 * 18.0 }px'></p>"
    end

  end
  
  #判断公司列表页标题 
  #如果关键字能批配到数据库里存的.就查找.如果没找到.就用列表页的
  def firm_list_title(city_code,price,style,model,index_html_metadata,page_title,district)
    has_title = true 
    city_name = CITIES[city_code.to_i]
    if price.to_i != 0 #价位通用
      html_metadata = HtmlMetadata.find_by_page_id("#{city_name}:装修点评:公司列表页-价位")
      price_name = (city_code.to_i == 12117) ? DecoFirm::NINBO_PRICE[price.to_i] : DecoFirm::PRICE[price.to_i]
      title = html_metadata.title % {:price => price_name}
    elsif style.to_i != 0 
      html_metadata = HtmlMetadata.find_by_page_id("#{city_name}:装修点评:公司列表页-#{DecoFirm::STYLES[style.to_i]}") 
      html_metadata.nil? ? has_title = false :  title = html_metadata.title
    elsif model.to_i != 0
      html_metadata = HtmlMetadata.find_by_page_id("#{city_name}:装修点评:公司列表页-#{DecoFirm::MODELS[model.to_i]}")
      html_metadata.nil? ?  has_title = false : title = html_metadata.title
    elsif district.to_i != 0
      html_metadata = HtmlMetadata.find_by_page_id("#{city_name}:装修点评:公司列表页-地区")
      html_metadata.nil? ?  has_title = false : title = html_metadata.title % {:district => HejiaTag.find_name(district)} 
    elsif page_title == "villa" 
      title = HtmlMetadata.find_by_page_id("#{city_name}:装修点评:公司列表页-别墅").title
    else
      has_title = false     
    end
    has_title ? title : "#{city_name}#{index_html_metadata.title}"
  end

 
end
