class OnlineController < PaintApplicationController 
  
   skip_filter :auto_expire, :only => [:send_index, :training,:send_info,:training_info]
  
  #在线派遣
  def send_index
    @paint_worker_id = params[:id]
    @paint_worker = PaintWorker.get_paint_worker @paint_worker_id #新规则：必须选择油漆工 
    if @paint_worker.nil?
      page_not_found!
    end
    @paint_send = PaintSend.new
  end
  
  #派遣回绝
  def send_refused
  end
  
  #派遣申请填写
  def send_info
    @paint_send = PaintSend.new params[:paint_send]
    @paint_send.brand = -1 if @paint_send.is_buy == 0

    if @paint_send.brand.to_i != -1 and @paint_send.paint_worker.painter.brand.to_i != @paint_send.brand.to_i
      redirect_to send_refused_path(:painter_worker_id => @paint_send.paint_worker.id)
    end
  end
  
  #保存派遣申请信息
  def send_create
#    year = params[:send_year]
#    month = params[:send_month]
    @paint_send = PaintSend.new params[:paint_send]
#    @paint_send.hope_date = "#{year}-#{month}-10"
    if @paint_send.save
      redirect_to :action => :success
    else
      render :action => :send_info
    end
  end
  
  def success
    
  end
  
  #得到在线派遣的城市
  def get_paint_send_citys
    province = params[:province]
    brand = params[:brand]
    province_name = Province.name_for_code(province)
    if PaintSend::BRANDS.index(brand.to_i) == "多乐士"
      cities = PaintSend::DUOLESHI_CITY[province_name]
    else
      cities = PaintSend::LAIWEIQI_CITY[province_name]
    end
    cities_array = []
    cities.each do |c|
      cities_array << [c, City.code_for_name(c)]
    end
    render :json => cities_array.to_json
  end
  
  #在线培训申请
  def training_info
    if user_logged_in?
      @paint_worker = PaintWorker.get_paint_worker current_user.id
      if @paint_worker.nil? || @paint_worker.painter.painters_status.to_i != 1
        @paint_worker = nil
      end
    end
    @paint_training = PaintTraining.new
  end
  
  def training_create
    @paint_training = PaintTraining.new params[:paint_training]
    if @paint_training.hope_grade.to_i != 3
      @paint_training.hope_spray_gun = 0
      @paint_training.hope_brush = 0
    end
    if @paint_training.save
      redirect_to :action => :success
    else
      render :action => :training
    end
  end
  
  def training
    @is_login = paint_worder_loggin?
  end

  def refused
    @paint_worker = PaintWorker.find params[:painter_worker_id]
  end
  
end