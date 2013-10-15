class PaintAdmin::PaintAdminsController < PaintAdmin::AdminController

  before_filter :find_paint_admin, :only => [:show,:edit,:update,:destroy,:edit_password]
  
  def index
    @paint_admins = PaintAdmin.username_like(params[:username]).
                               userbbsname_like(params[:userbbsname]).
                               email_is(params[:userbbsemail]).
                              paginate(:all,:order=>"CREATTIME desc",:per_page=>20,:page=>params[:page_id])
  end
  
  def new
    @paint_admin = PaintAdmin.new
  end
  
  def create
    @paint_admin = PaintAdmin.new params[:paint_admin]
    @paint_admin.USERNAME = params[:user_name]
    @paint_admin.USERSPASSWORD = params[:password]
    @paint_admin.set_roles(params[:roles])
    if  @paint_admin.save 
      flash[:notice] = "用户创建成功"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
  
  def edit;end
  
  def update
    @paint_admin.set_roles(params[:roles])
    if @paint_admin.update_attributes(params[:paint_admin])
      flash[:notice] = "用户资料修改成功"
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end
  
  def destroy
    @paint_admin.destroy
    flash[:notice] = "删除成功"
    redirect_to :action => :index
  end
  
   #修改密码
  def edit_password
    @admin_id = params[:id]
  end
  
    
  def update_password
    password = params[:password]
    id = params[:id]
    admin = PaintAdmin.find_by_USERBBSID(id)
    if admin.password_update(password)
      flash[:notice] = "密码修改成功"
      redirect_to :action => :index
    else
      render :action => :edit_password
    end
  end
  
private
  
  def find_paint_admin
    @paint_admin = PaintAdmin.find(params[:id])
  end
  
end