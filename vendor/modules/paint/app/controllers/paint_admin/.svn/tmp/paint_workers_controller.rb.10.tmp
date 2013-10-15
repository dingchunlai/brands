class PaintAdmin::PaintWorkersController < PaintAdmin::AdminController
  
  load_and_authorize_resource
  before_filter :find_paint_worker, :only => [:edit,:update,:destroy]
  
  def index
    @grade, @userbbsname, @email, @phone, @id_number, @province= params.values_at(:grade, :userbbsname, :email, :phone, :id_number, :province)
    @paint_workers = PaintWorker.find_paint_worker(params).paginate :page => params[:page], :per_page => 10
  end
  
  def update
    if params[:paint_worker][:painter_attributes][:education] == "其它"
      params[:paint_worker][:painter_attributes][:education] = params[:education_other]
    end
    if params[:paint_worker][:painter_attributes][:know_here] == "其它"
      params[:paint_worker][:painter_attributes][:know_here] = params[:know_here_other]
    end
    if params[:paint_worker][:painter_attributes][:job] == "其它"
      params[:paint_worker][:painter_attributes][:job] = params[:job_other]
    end
    unless params[:trial_products_other].blank?
      unless params[:paint_worker][:painter_attributes][:trial_products].blank?
        params[:paint_worker][:painter_attributes][:trial_products] = params[:paint_worker][:painter_attributes][:trial_products] + params[:trial_products_other].to_a
      else
        params[:paint_worker][:painter_attributes][:trial_products] = params[:trial_products_other].to_a
      end      
    end
    if @paint_worker.update_attributes(params[:paint_worker])
      flash[:notice] = "修改成功"
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
  
  def new
    @paint_worker = PaintWorker.new
  end
  
  def create
    @paint_worker = PaintWorker.new params[:paint_worker]
    #@paint_worker.USERNAME =  params[:paint_worker][:USERBBSMOBELTELEPHONE]
    @paint_worker.painter.painters_status = 1
    @paint_worker.USERSPASSWORD = PAINT_WORKER_INITIAL_PASSWORD
    if @paint_worker.painter.education == "其它"
      @paint_worker.painter.education = params[:education_other]
    end
    if @paint_worker.painter.know_here == "其它"
      @paint_worker.painter.know_here = params[:know_here_other]
    end
    if @paint_worker.painter.job == "其它"
      @paint_worker.painter.job = params[:job_other]
    end
    unless params[:trial_products_other].blank?
      if @paint_worker.painter.trial_products.nil?
        @paint_worker.painter.trial_products = params[:trial_products_other].to_a
      else
        @paint_worker.painter.trial_products = @paint_worker.painter.trial_products + params[:trial_products_other].to_a
      end
    end
    if @paint_worker.save
      flash[:notice] = "创建成功"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
  end 
  
  #油漆工撤销
  def destroy
    if @paint_worker.painter.trash
      flash[:notice] = "操作成功"
      redirect_to :action => :index
    end
  end
  
  
  #油漆工申请列表页面
  def applicants
    @data = params[:applicant_data]
    @status = params[:painters_status].blank? ? 2 : params[:painters_status]
    @paint_workers = PaintWorker.by_painter(@status, @data).paginate :page => params[:page], :per_page => 10
  end
  
  #油漆工申请通过
  def accept
    ids = params[:painter_ids]
    unless ids.nil?
      ids.each do |id|
       painter = Painter.find(id)
       painter.agree
      end
      flash[:notice] = "操作成功"
    end
    redirect_to :action => :index
  end
  
  #油漆工申请驳回
  def overrule
    id = params[:painter_id]
    painter = Painter.find(id)
    if painter.reject
      flash[:notice] = "操作成功"
      redirect_to :action => :index
    end
  end
  
  #修改密码
  def edit_password
    @painter_id = params[:id]
  end
  
   #重置密码
  def reset_password
    id = params[:this_id]
    reset = params[:reset]
    password = reset.blank? ? params[:password] : PAINT_WORKER_INITIAL_PASSWORD
    paint_worker = PaintWorker.find(id)
    if paint_worker.password_reset password
      flash[:notice] = "修改密码成功"
      redirect_to :action => :index
    end
  end
  
  #回收站
  def recycle
    @paint_workers = PaintWorker.by_painter(4, nil).paginate :page => params[:page], :per_page => 10
  end
  
  #恢复
  def regain
    ids = params[:painter_ids]
    unless ids.nil?
      ids.each do |id|
       painter = Painter.find(id)
       painter.regain
      end
      flash[:notice] = "操作成功"
    end
    redirect_to :action => :applicants
  end
  

  private
  def find_paint_worker
    @paint_worker = PaintWorker.find(params[:id])
  end
  
  
end