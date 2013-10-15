module PaintAdmin::PaintLogHelper
  
  def log_show paint_log
    position = ''
    case paint_log.item_type
    when "PaintWorker"
      position = "油漆工管理"
    when "Painter"
      position = "油漆工管理"
    when "PaintContact"
      position = "联络列表"
    when "PaintAdmin"
      position = "账户管理"
    when "PaintCase"
      position = "案例管理"
    end
    date = " >> 时间：#{paint_log.created_at.strftime('%Y-%m-%d %H:%M:%S')}"
    admin = " >> 管理员(#{paint_log.user_name})"
    change = paint_log.change_content
    position  + admin + change + date
  end
  
 
end