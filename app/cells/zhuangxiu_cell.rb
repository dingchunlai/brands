class ZhuangxiuCell < ApplicationCell

  #cache :my_coupons

  # 装修公司推荐
  def gong_si_tui_jian
    #@decofirms = DecoFirm.find(:all,:select=>"id,name_zh,name_abbr,total_score,city,district", :conditions => ["id in (?)",Applicant.applicat_top(6).for_city("11910").map{|a|a.deco_firm_id}])

    @sql = "select f.id, f.name_zh, f.name_abbr, f.total_score, f.city, f.district,count(a.deco_firm_id) as count from applicants a join deco_firms f "
    @sql += "on a.deco_firm_id = f.id where f.is_cooperation = 1 and a.confirm_at > '#{1.month.ago.to_date.to_s}' and (f.city = 11910 or f.district = 11910) "
    @sql += "group by a.deco_firm_id order by count(a.deco_firm_id) desc, f.praise DESC limit 6"

    @decofirms = DecoFirm.find_by_sql(@sql)

    render
  end

  # 装修公司图片和促销
  def tu_pian_cu_xiao
    city_id = @opts[:city_id].to_i
    @tu_pian = Case.find(:all,  :select=>"NAME, ID, PROVINCE1", :conditions => "STATUS!='-100' and ISNEWCASE=1 and TEMPLATE != 'room' and ISZHUANGHUANG='1'",  :order => "ID desc",  :limit => 12)
    @cu_xiao = DecoEvent.promoted_events(city_id)
    render
  end

  def mei_jia_tui_jian
    @zhuangxiu_diaries = hejia_promotion_items(54215, :attributes => ['title','url','image_url','description'], :limit => 4)
    render
  end

  # 根据城市提取一家装修公司
  def tui_jian_gong_si
    city_id = @opts[:city_id].to_i
    article_id = @opts[:article_id].to_i
    @tui_jian_gong_si = DecoFirm.get_a_cooperation_firm(article_id, city_id) if article_id > 0
    render
  end

end
