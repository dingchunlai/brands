class PaintAdmin::ContactsController < PaintAdmin::AdminController
  
#  load_and_authorize_resource
  
  before_filter :find_paint_contact, :only => [:edit,:update,:destroy]

  def index
    @people, @phone, @city, @province = params.values_at(:people, :phone, :city, :province)
    @contacts = PaintContact.by_contact(params).paginate :page => params[:page], :per_page => 10
  end
  
  def update
    if @paint_contact.update_attributes(params[:paint_contact])
      flash[:notice] = "修改成功"
      redirect_to :action => :index
    end
  end
  
  def new
    @paint_contact = PaintContact.new
  end
  
  def create
    @paint_contact = PaintContact.new params[:paint_contact]
    if @paint_contact.save
      flash[:notice] = "创建成功"
      redirect_to :action => :index
    end
  end
  
  def edit
    
  end
  
  def destroy
    if @paint_contact.destroy
      flash[:notice] = "删除成功"
      redirect_to :action => :index
    end
  end
  
   #得下省下的城市(ajax)
  def get_cities
    province = params[:province]
    cities = PaintContact.cities_for_province province
    render :json => cities
  end
  
   #导出xls
  def xls_contacts
    @contacts = PaintContact.find(:all)
  end
   
  private 
  def find_paint_contact
    @paint_contact = PaintContact.find(params[:id])
  end
  
end