module Dianping::HomeHelper
  # TODO Generated stub
  #首页用的促销活动
  def cu_xiao_huo_dong(city_code)
    Hejia[:cache].fetch "dianping:home:#{city_code}:cu_xiao_huo_dong", 30.minutes do
      hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[city_code.to_i]]['促销活动'], :attributes => ['title','url','image_url'],:limit => 4)
    end
  end
  #首页用的装修专题
  def ben_di_zi_xun(city_code)
    Hejia[:cache].fetch "dianping:home:#{city_code}:ben_di_zi_xun", 30.minutes do
      hejia_promotion_items(ZHUANGXIU_DIANPING_INDEX_PROMOTED[TAGURLS[city_code.to_i]]['本地资讯'], :attributes => ['title','url','image_url'],:limit => 4)
    end
  end


  #首页右侧资讯
  def new_cu_xiao_huo_dong(city_code)
    Hejia[:cache].fetch "dianping:home:#{city_code}:new_cu_xiao_huo_dong", 30.minutes do
      hejia_promotion_items(NEW_DIANPING_HOME_API[TAGURLS[@user_city_code.to_i]]['资讯'], :attributes => ['title','url','image_url'],:limit => 5)
    end
  end
  #首页右侧专题
  def new_ben_di_zi_xun(city_code)
    Hejia[:cache].fetch "dianping:home:#{city_code}:new_ben_di_zi_xun", 30.minutes do
      hejia_promotion_items(NEW_DIANPING_HOME_API[TAGURLS[@user_city_code.to_i]]['专题'], :attributes => ['title','url','image_url'],:limit => 2)
    end
  end

  #得到日记评分,显示星星 diary_praise.round.to_f / 2.0 * 18.0
  def get_diary_praise(diary)
    if diary && diary.status == 1 && diary.praise.to_i >0
      if diary.is_verified.to_i != 1 && diary.finished == false
        diary.praise.to_i * 0.8
      elsif diary.is_verified.to_i == 1 && diary.finished == true
        diary.praise.to_i
      else
        diary.praise.to_i * 0.9
      end
    else
     0
    end
  end

  #截取中文 跟英文保持一致
  def truncate_for_zh(str = '',str_count = 0)
    s = ''
    str_sp = str.split(//u)
    str_sp.inject(0) do |sum,obj|
      break if sum >= str_count
      (obj.size == 3) ? sum += 2 : sum += 1
      s << obj
      sum
    end
    s.blank? ? str : s
  end

  #去掉<!--
  def remove_comment_tag tag
    tag.gsub(/<!--/,'').gsub(/-->/,'')
  end


end