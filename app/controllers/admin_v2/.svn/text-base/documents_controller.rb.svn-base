class AdminV2::DocumentsController < AdminV2Controller

  before_filter :find_brand, :except => :create

  def index
    @documents = @brand.documents.paginate :page => page
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new params[:document]
    @document.brand_id = params[:brand_id]
    if @document.save
      flash[:notice] = '资料添加成功'
      redirect_to admin_brand_documents_url(params[:brand_id])
    else
      flash[:alter] = '资料添加失败'
      render :action => :new
    end
  end

  def destroy
    document = Document.find params[:id]
    if document.filename
      document.destroy
    else
      document.delete
    end
    #Document.destroy params[:id]
    flash[:notice] = '资料已被删除'
    redirect_to :back
  end

  private
  def find_brand
    @brand = Brand.find(params[:brand_id]) if params[:brand_id]
  end
end
