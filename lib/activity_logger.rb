module ActivityLogger

  #创建日志
  def add_activities(options = {})
    PaintLog.create!(:item => options[:item],:change_content => options[:change])
  end
  
end