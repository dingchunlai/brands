module Dianping::CasesHelper
  #seo部门定的title
  #有几个关键字的title唯一..其它的关键字匹配通用的title 
  def cases_list_title(city_code,price,style,model,room,index_html_metadata)
    keywords = ["现代简约","田园风格","欧美式","中式风格","地中海","混搭","小户型","别墅","复式"] #数据库收库的关键字(人工的)
    city_name = CITIES[city_code.to_i]
    if price.to_i != 0
      price_name = ([12117,12301].include? city_code.to_i) ? DecoFirm::NINBO_PRICE[price.to_i] : DecoFirm::PRICE[price.to_i]
      (keywords.include? price_name) ?  HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-#{price_name}").title : HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-通用").title % {:condition => price_name}
    elsif style.to_i != 0
      (keywords.include? STYLES[style.to_i]) ?  HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-#{STYLES[style.to_i]}").title : HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-通用").title % {:condition => STYLES[style.to_i]}
    elsif model.to_i != 0
      (keywords.include? MODELS[model.to_i]) ?  HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-#{MODELS[model.to_i]}").title : HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-通用").title % {:condition => MODELS[model.to_i]}
    elsif room.to_i != 0
      (keywords.include? ROOM[room.to_i]) ?  HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-#{ROOM[room.to_i]}").title : HtmlMetadata.find_by_page_id("#{city_name}:装修点评:案例图片列表页-通用").title % {:condition => ROOM[room.to_i]}
    else
      index_html_metadata.title % {:city_name => city_name }      
    end
  end
end