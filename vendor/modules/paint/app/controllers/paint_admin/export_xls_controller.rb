class PaintAdmin::ExportXlsController < PaintAdmin::AdminController
  
  
  def index
    
  end
  
   #导出油漆工
  def xls_paint_workers
    is_applicant = params[:is_applicant]
    filename = is_applicant.to_i == 2 ?"yougongshenqing" : "yougong"
    headers['Content-Type'] = "application/vnd.ms-excel"  
    headers['Content-Disposition'] = "attachment; filename=#{filename}.xls"  
    headers['Cache-Control'] = ''
    start_date = params[:start_date]
    end_date = params[:end_date]
    
    @paint_workers = PaintWorker.xls(is_applicant,start_date, end_date)
    render :layout =>  false
  end
  
  #导出在线派遣
  def xls_sends
    headers['Content-Type'] = "application/vnd.ms-excel"  
    headers['Content-Disposition'] = 'attachment; filename="paiqian.xls"'  
    headers['Cache-Control'] = ''
    start_date = params[:start_date]
    end_date = params[:end_date]
    @sends = PaintSend.xls(start_date, end_date)
    render :layout =>  false
  end
  
  #导出案例
  def xls_cases
    headers['Content-Type'] = "application/vnd.ms-excel"  
    headers['Content-Disposition'] = 'attachment; filename="anli.xls"'
    headers['Cache-Control'] = ''
    start_date = params[:start_date]
    end_date = params[:end_date]
    @cases= PaintCase.created_at_after(start_date).created_at_before(end_date).status_is(1)
    render :layout =>  false
  end
  
 #导出联络列表
  def xls_contacts
    headers['Content-Type'] = "application/vnd.ms-excel"  
    headers['Content-Disposition'] = 'attachment; filename="fuwuzhongxin.xls"'
    headers['Cache-Control'] = ''
    start_date = params[:start_date]
    end_date = params[:end_date]
    @contacts = PaintContact.xls(start_date, end_date)
    render :layout =>  false
  end
  
  #导出在线培训申请
  def xls_training
    headers['Content-Type'] = "application/vnd.ms-excel"  
    headers['Content-Disposition'] = 'attachment; filename="zaixianpeixun.xls"'
    headers['Cache-Control'] = ''
    start_date = params[:start_date]
    end_date = params[:end_date]
    @trainings = PaintTraining.xls(start_date, end_date)
    render :layout =>  false
  end

  def xls_concerned_paint
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="guanzhuzhilian.xls"'
    headers['Cache-Control'] = ''
    start_date = params[:start_date]
    end_date = params[:end_date]
    @concerned_paint = HejiaUserBbs.xls(start_date, end_date)
    render :layout => false
  end
  
end