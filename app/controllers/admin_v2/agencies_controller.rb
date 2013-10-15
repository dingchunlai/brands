class AdminV2::AgenciesController < AdminV2Controller

  before_filter :validate_tagged_brand

  def index
    agency = Agency
    @agencies = agency.with_tagged_brand(@tagged_brand.id)
  end

  def new
    @agency = Agency.new
    render :action => :edit
  end

  def edit
    @agency = Agency.find params[:id]
  end

  def create
    params[:agency][:tagged_brand_id] = params[:tagged_brand_id]
    @agency = Agency.new(params[:agency])
    if @agency.save
      flash[:notice] = "创建成功 !"
    else
      flash[:alert] = "创建失败 ! #{@agency.errors.full_messages.join('<br />')} "
    end
    redirect_to new_admin_brand_agency_path(@brand, :tag_id => @tag.TAGID)
  end

  def update
    @agency = Agency.find params[:id]
    if @agency.update_attributes params[:agency]
      flash[:notice] = "修改成功 !"
    else
      flash[:alert] = "修改失败 !"
    end
    redirect_to :back
  end

  def destroy
    flash[:notice] = '删除成功 !'
    Agency.destroy params[:id]
    redirect_to :back
  end

end
