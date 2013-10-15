module Dianping::DecorationDiariesHelper

  # 得到公司的所有日记数量
  def get_firm_diaries_count(firm_id)
    Hejia[:cache].fetch("get_firm_diaries_count/DecorationDiary/#{firm_id}",5.hours) do
      DecorationDiary.count(:conditions => "deco_firm_id = #{firm_id} and status =1")
    end
  end

  #得到公司最新三条评论
  def get_firm_remarks_top3(firm_id)
    Hejia[:cache].fetch("get_firm_remarks_top3/Remark/#{firm_id}",5.minutes) do
      Remark.find(:all ,
        :conditions => "resource_type = 'DecoFirm' and resource_id = #{firm_id}",
        :order => "created_at desc",
        :limit => 3)
    end
  end

  #得到推广公司信息
  def get_firm_by_id(deco_firm)
    Hejia[:cache].fetch("get_firm_by_id/firm/#{deco_firm.district.to_i}",1.day) do
      #city = deco_firm.city.to_i == 11910 ? 'shanghai' : TAGURLS[deco_firm.district.to_i]
      city = if deco_firm.city.to_i == 11910
                'shanghai'
             elsif deco_firm.city.to_i == 11905
                'beijing'
             elsif deco_firm.city.to_i == 31959
                'guangzhou'
             else
                TAGURLS[deco_firm.district.to_i]
             end
      firms_title = parse_xml(DECOFIRM_PROMOTED_DIARY['日记终端页'][city], ['title'])
      firms_id = firms_title.map{|f| f["title"].to_i}
      DecoFirm.find(
        :all,
        :conditions => ["id in (?)",firms_id],
        :limit => 5)
    end
  end
  
end
