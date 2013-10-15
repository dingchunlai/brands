module Dianping::ThemeHelper
  
  #判断是专题还专访
  def title_name(city_name,column_id)
      if ZHUANGXIU_DIANPING_INDEX_PROMOTED[city_name]['专题'] == column_id
        "【专题】"
      elsif ZHUANGXIU_DIANPING_INDEX_PROMOTED[city_name]['专访'] == column_id
        "【专访】"
      end
  end

  def new_title_name(city_name,column_id)
      if NEW_DIANPING_HOME_API[city_name]['资讯'] == column_id
        "【资讯】"
      elsif NEW_DIANPING_HOME_API[city_name]['专题'] == column_id
        "【专题】"
      elsif NEW_DIANPING_HOME_API[city_name]['装修公司谈装潢'] == column_id
        "【谈装潢】"
      end
  end
end