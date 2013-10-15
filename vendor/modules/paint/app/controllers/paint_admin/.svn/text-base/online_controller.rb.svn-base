class PaintAdmin::OnlineController < PaintAdmin::AdminController
  
  def send_index
    @status, @start_date, @end_date, @hope_start_date, @hope_end_date  = params.values_at(:status, :start_date, :end_date, :hope_start_date, :hope_end_date)
    @sends = PaintSend.by_all(params).paginate :page => params[:page], :per_page => 10
  end
  
  def send_new
    @paint_worker = PaintWorker.get_paint_worker params[:paint_worker_id]
    @paint_send = PaintSend.new
  end
  
  def send_create
    year = params[:send_year]
    month = params[:send_month]
    @paint_send = PaintSend.new params[:paint_send]
    @paint_send.hope_date = "#{year}-#{month}-10"
    if @paint_send.save
        redirect_to :action => :send_index
    else
        render :action => :send_new
    end
  end
  
  def send_destroy
    ids = params[:send_ids]
    unless ids.nil?
      ids.each do |id|
       paint_send = PaintSend.find(id)
       paint_send.destroy
      end
      flash[:notice] = "操作成功"
    end
    redirect_to :action => :send_index
  end
  
  #修改在线派遣备注
  def update_send_remark
    remark = params[:remark]
    id = params[:id]
    send = PaintSend.find(id)
    send.update_remark( remark)
    render :json => {:result => true}.to_json
  end
  
  #在线培训列表
  def training
    @status, @start_date, @end_date = params.values_at(:status, :start_date, :end_date)
    @trainings = PaintTraining.by_all(params).paginate :page => params[:page], :per_page => 10
  end
  
  def training_destroy
    ids = params[:training_ids]
    unless ids.nil?
      ids.each do |id|
       training = PaintTraining.find(id)
       training.destroy
      end
      flash[:notice] = "操作成功"
    end
    redirect_to :action => :training
  end
  
   #修改在线培训备注
  def update_training_remark
    remark = params[:remark]
    id = params[:id]
    training = PaintTraining.find(id)
    training.update_remark(remark)
    render :json => {:result => true}.to_json
  end
  
end