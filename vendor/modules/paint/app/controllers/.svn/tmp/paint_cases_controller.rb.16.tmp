class PaintCasesController < PaintApplicationController 
  
  helper 'PaintAdmin::PaintCases'
  
  before_filter :validate_admin, :only => [:admin_index, :new, :draft, :edit,:success]
  before_filter :find_paint_case, :only => [:edit, :update]
  before_filter :vallidate_case, :only => [:show]
  before_filter :validate_case_is_paint_worker, :only => [:edit, :update]
  #skip_filter :auto_expire, :except => [:index, :show]
  
  
  
  def index
    @location = "全部案例"
    @cases = PaintCase.status_is(1).find(:all, :order => "created_at desc").paginate :page => params[:page], :per_page => 5
  end
  
  def show
    
  end
  
  def my_cases
    essence = params[:essence]
    paint_worker_id = params[:id]
    paint_worker = PaintWorker.get_paint_worker paint_worker_id
    if essence == "essence"
      @location = "#{paint_worker.USERBBSNAME}的精华案例"
      @cases = paint_worker.paint_cases.essence_case.paginate :page => params[:page], :per_page => 5
    else
      @location = "#{paint_worker.USERBBSNAME}的全部案例"
      @cases = paint_worker.paint_cases.status_is(1).find(:all, :order => "created_at desc").paginate :page => params[:page], :per_page => 5
    end
    render "index"
  end
  
  
  def admin_index
    @my_cases = @paint_worker.paint_cases.exception_draft.paginate :page => params[:page], :per_page => 3
  end
  
  def new
    @paint_case = PaintCase.new
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  #精华案例
  def essence_case
    @cases = PaintCase.essence_case.paginate :page => params[:page], :per_page => 5
    @location = "精华案例"
    render "index"
  end
  
  
  def create
    its_id = params[:id]
    params[:paint_case][:status] = params[:status].to_i == 0 ? 0 : 2
    unless params[:other_wood_paint].blank?
      if params[:paint_case][:wood_paint].nil?
        params[:paint_case][:wood_paint] = params[:other_wood_paint].to_a
      else
        params[:paint_case][:wood_paint] = (params[:paint_case][:wood_paint] + params[:other_wood_paint].to_a)
      end
    end
    if params[:paint_case][:renovation] == "其它"
      params[:paint_case][:renovation] = params[:other_renovation]
    end
    @paint_case = its_id.blank? ? PaintCase.new(params[:paint_case]) : PaintCase.find(params[:id])
    if its_id.blank? ? @paint_case.save : @paint_case.update_attributes(params[:paint_case])
      save_pictures
      render :json => {"time" =>"保存于 #{Time.now.to_s(:db)}" , "id" => @paint_case.id }.to_json
    else
      render :nothing => true
    end
  end
  
  #草稿列表
  def draft
    @my_cases = @paint_worker.paint_cases.status_is(2).paginate :page => params[:page], :per_page => 3
  end
  
  def delete
    ids = params[:cases_ids]
    unless ids.nil?
      ids.each do |id|
       PaintCase.update_all("status = -1 ","id = #{id}")
      end
      flash[:notice] = "操作成功"
    end
    redirect_to :back
  end
  
  def success
    
  end
  
  
  #  private ---------华丽的分割线---------------------------------------
  private
  def find_paint_case
    @paint_case = PaintCase.find(params[:id])
    unless @paint_case.status == 0 || @paint_case.status == 2
      return
    end
  end
  
  def save_pictures
    unless params[:pictures].nil?
      params[:pictures].each do |picture|
        if @picture = CloudPicture.find_by_image_id(picture[:image_id])
          @picture.update_attributes(picture)
        else
          @picture = CloudPicture.new(picture)
          @picture.item = @paint_case
          @picture.save
        end
      end
      master_picture_image_id = params[:pictures][0][:is_master]
      CloudPicture.update_all("is_master = 0 ",["item_type = 'PaintCase' and item_id = ?",@paint_case.id])
      CloudPicture.update_all("is_master = 1 ",:image_id => master_picture_image_id)
    end
  end
  
  
  #验证该案例是否属于自己，防止根据URL修改别人的案例
  def validate_case_is_paint_worker
    unless @paint_worker.id == @paint_case.paint_worker_id
      page_not_found!
    end
  end
  
  #验证该案例是否是正常状态
  def vallidate_case
    id = params[:id]
    @paint_case = PaintCase.find_by_id id
    unless !@paint_case.nil? && @paint_case.status == 1
      page_not_found!
    end
  end
  
end