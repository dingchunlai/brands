class PaintWorkersController < PaintApplicationController 
  
  helper PaintAdmin::PaintWorkersHelper
  
  before_filter :validate_paint_worker, :only => [:index]
  before_filter :validate_admin, :only => [:admin_index, :admin_edit, :admin_update,:edit_password,:update_password,:help]
  skip_filter :auto_expire, :except => [:index, :renzheng, :all , :success] #只缓存这几个
#  skip_filter :auto_expire, :only => [:admin_index, :admin_edit, :edit_password, :admin_update,:update_password]
  def index

  end
  
  #油漆工个人后台
  def admin_index

  end
  
  #认证油工
  def renzheng
    remote_location = ChunzhenIp.default.find_location_by_ip request.remote_ip
    params[:province] = remote_location && remote_location.province && remote_location.province.to_pinyin || 'shanghai'
    @paint_workers = PaintWorker.find_paint_worker(params).find(:all,:limit => 8)
    if @paint_workers.size < 8
      @paint_workers = @paint_workers + PaintWorker.renzheng(8 - @paint_workers.size)
    end
    
  end
 
  def all
    @city, @province = params.values_at(:city, :province)
    @paint_workers = PaintWorker.by_all(params).paginate :page => params[:page], :per_page => 10
  end
  
  #油漆工个人后台编辑
  def admin_edit
  end
  #油漆工密码修改
  def edit_password
  end
  #油漆工个人后台修改
  def admin_update
    password = params[:password]
    if @paint_worker.validate_passrord(password)
      if @paint_worker.update_attributes(params[:paint_worker])
        flash[:notice] = "修改成功"
        redirect_to :action => :admin_index
      else
        render :action => :admin_edit
      end
    else
      flash[:notice] = "密码错误"
      render :action => :admin_edit
    end
  end
    
  def update_password
    now_password = params[:now_password]
    password = params[:password]
    if @paint_worker.validate_passrord(now_password)
      if @paint_worker.password_reset password
        flash[:notice] = "修改成功"
        redirect_to :action => :admin_index
      else
        render :action => :admin_edit
      end
    else
      flash[:notice] = "密码错误"
      render :action => :edit_password
    end
  end
  #油漆工申请
  def applicant
    @paint_worker = PaintWorker.new
  end
  
  #油漆工个人申请添加
  def save 
    @paint_worker = PaintWorker.new params[:paint_worker]
    @paint_worker.USERNAME = @paint_worker.USERBBSMOBELTELEPHONE = params[:user_name]
    @paint_worker.painter.painters_status = 2
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
      redirect_to :action => :success
    else
      render :action => :applicant
    end
  end
  
  def success
  end
  
  def help
    @key = params[:key]
  end
  
   #得下省下的城市(ajax)
  def get_paint_cities
    province = params[:province]
    cities = City.get_cities_for_province_jinshuazi(province)
    render :json => cities
  end
  
  #  private ---------------------------华丽的分割线---------------------------------------
  private
  def validate_paint_worker
    id = params[:id]
    @paint_worker = PaintWorker.get_paint_worker id
    unless !@paint_worker.nil? && @paint_worker.painter.painters_status == 1
      page_not_found!
    end
  end
  
end
