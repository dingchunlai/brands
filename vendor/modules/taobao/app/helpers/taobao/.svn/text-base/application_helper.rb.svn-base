module Taobao::ApplicationHelper
  
  def zq_url(keyword)

        if keyword.length == 0
          prefix = "http://tag.51hejia.com"
          url = "/"
        elsif !(redirect_key_url = get_redirect_key_url(keyword)).nil?
          url = redirect_key_url
        elsif !(s = ZhuanquSort.find_by_sort_name(keyword,:select=>"id, board_id")).nil?
          prefix = "http://#{ZHUANQU_BOARD_SPELL[s.board_id.to_i]}.51hejia.com"
          url = "/zq/#{keyword}/"
        elsif !(k =ZhuanquKw.find_by_kw_name(keyword,:select=>"id,sort_id")).nil?
          s = ZhuanquSort.find(k.sort_id,:select=>"id, board_id, sort_name")
          sort_name = s.sort_name rescue "栏目"
          board_id = s.board_id
          prefix = "http://#{ZHUANQU_BOARD_SPELL[board_id.to_i]}.51hejia.com"
          url = "/zq/#{sort_name}-#{keyword}.html"
        else
          url = "http://tag.51hejia.com/#{keyword}.html"
        end
        url 

  end
  
  #获得url和image_url
  def get_article_url_image_url(article_id, firstcategory, create_time, image_name)
    tag = HejiaTag.find(:first, :select => "TAGURL", :conditions => ["TAGID = ?", firstcategory])

    if image_name.nil?
      image_url = "http://www.51hejia.com/api/images/none.gif"
    else
      if image_name.include?("img")
        image_url = "http://d.51hejia.com/files/hekea/article_img/sourceImage/#{image_name[3..10]}/#{image_name} "
      else
        image_url = "http://d.51hejia.com/files/hekea/article_img/sourceImage/#{create_time.strftime("%Y%m%d")}/#{image_name} "
      end
    end
    image_url
  end
  
  def get_redirect_key_url(name)
    if @redirect_key.nil?
      @redirect_key = Hash.new
      @redirect_key["新闻"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["行业"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["资讯"] = "http://www.51hejia.com/xinwen/"
      @redirect_key["卖场"] = "http://www.51hejia.com/maichang/"
      @redirect_key["博客"] = "http://blog.51hejia.com/"
      @redirect_key["装修"] = "http://d.51hejia.com/"
      @redirect_key["地板"] = "http://www.51hejia.com/diban/"
      @redirect_key["涂料"] = "http://www.51hejia.com/youqituliao/"
      @redirect_key["油漆"] = "http://www.51hejia.com/youqituliao/"
      @redirect_key["瓷砖"] = "http://www.51hejia.com/cizhuan/"
      @redirect_key["布艺"] = "http://www.51hejia.com/buyi/"
      @redirect_key["家具"] = "http://www.51hejia.com/jiajuchanpin/"
      @redirect_key["家电"] = "http://www.51hejia.com/jiadian/"
      @redirect_key["灯具"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["灯饰"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["照明"] = "http://www.51hejia.com/zhaomingpindao/"
      @redirect_key["采暖"] = "http://www.51hejia.com/cainuan/"
      @redirect_key["厨房橱柜"] = "http://www.51hejia.com/chuguipindao/"
      @redirect_key["卫生间用品"] = "http://www.51hejia.com/weiyupindao/"
      @redirect_key["洗手间用品"] = "http://www.51hejia.com/weiyupindao/"
      @redirect_key["中央空调"] = "http://www.51hejia.com/kongtiao/"
      @redirect_key["水处理"] = "http://www.51hejia.com/shuichuli/"
      @redirect_key["装饰"] = "http://www.51hejia.com/jushang/"
      @redirect_key["时尚家居"] = "http://www.51hejia.com/jushang/"
      @redirect_key["厨房"] = "http://www.51hejia.com/chufang/"
      @redirect_key["卫浴"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["卫生间"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["洗手间"] = "http://www.51hejia.com/weiyu/"
      @redirect_key["客厅"] = "http://www.51hejia.com/keting/"
      @redirect_key["卧室"] = "http://www.51hejia.com/woshi/"
      @redirect_key["书房"] = "http://www.51hejia.com/shufang/"
      @redirect_key["花园"] = "http://www.51hejia.com/huayuanshenghuo/"
      @redirect_key["背景墙"] = "http://www.51hejia.com/beijingqiang/"
      @redirect_key["儿童房"] = "http://www.51hejia.com/ertongfang/"
      @redirect_key["小户型"] = "http://www.51hejia.com/xiaohuxing/"
      @redirect_key["公寓"] = "http://www.51hejia.com/gongyu/"
      @redirect_key["二手房"] = "http://www.51hejia.com/ershoufang/"
      @redirect_key["主妇"] = "http://www.51hejia.com/chaojizhufu/"
      @redirect_key["别墅"] = "http://www.51hejia.com/bieshu/"
      @redirect_key["品牌"] = "http://b.51hejia.com/"
    end
    return @redirect_key[name]
  end
  

end