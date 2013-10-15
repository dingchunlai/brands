module PaintCasesHelper
  
  def get_case_link this_case
    if this_case.status.to_i == 0 
      url = edit_paint_case_path(this_case.id)
      status = "未审核"
      link = "<a href='#{edit_paint_case_path(this_case.id)}' class='yg_web_anlibtn01'>编辑</a>"
    else
      url = get_paint_case_url(this_case.id)
      status = "已审核"
      link = "<a href='#{get_paint_case_url(this_case.id)}' class='yg_web_anlibtn01'>查看</a>"
    end
    {
      :url => url,
      :status => status,
      :link => link
    }
  end
  
  def essence this_case
    this_case.essence ? "<div class='yg_listp1_jddp'>经典案例</div>" : ""
  end
  
  def top_navigation location
    all_case_link = "<a href='/cases' target='_self' title='油漆工案例' >油漆工案例</a>"
    location == '全部案例' ? "油漆工案例" : all_case_link
  end
    
end