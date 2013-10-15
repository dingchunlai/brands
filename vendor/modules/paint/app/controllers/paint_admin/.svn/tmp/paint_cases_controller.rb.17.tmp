require 'cgi'
class PaintAdmin::PaintCasesController < PaintAdmin::AdminController
  
  before_filter :find_paint_case, :only => [:update, :edit,:set_essence, :destroy]
  
  def index
    @paint_cases = PaintCase.created_at_after(params[:from]).
      created_at_before(params[:to]).
      title_like(params[:title]).
      status_is(params[:status]).
      paint_worker_name_is(params[:paint_worker_name]).
      except_status.
      paginate(:all, :conditions=>"status <> 2", :order=>"created_at desc", :include => :paint_worker, :page=>params[:page], :per_page => 15)
  end
  
  def new
    @paint_case = PaintCase.new(:status => 0)
    @wcs = [WoodConstructionSpecification.new(),WoodConstructionSpecification.new()]
    @ps = [ProductSpecification.new(),ProductSpecification.new()]
    @paint_worker_id = params[:paint_worker_id]
    @paint_worker = PaintWorker.find(params[:paint_worker_id]) if @paint_worker_id
    @painter = Painter.new()
    @painter = @paint_worker.painter if @paint_worker and @paint_worker.painter
  end


  def create
    params[:paint_case][:status] = 0 if params[:status].to_i == 0
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

    ps_hash = params[:paint_case]["product_specifications_attributes"]
    params[:paint_case]["product_specifications_attributes"].map do |ps|
      @ps = ProductSpecification.new(ps[1])
      ps_hash.delete(ps[0]) unless @ps.valid?
    end
    params[:paint_case]["product_specifications_attributes"] = ps_hash

    wcs_hash = params[:paint_case]["wood_construction_specifications_attributes"]
    params[:paint_case]["wood_construction_specifications_attributes"].map do |wcs|
      @wcs = WoodConstructionSpecification.new(wcs[1])
      wcs_hash.delete(wcs[0]) unless @wcs.valid?
    end
    params[:paint_case]["wood_construction_specifications_attributes"] = wcs_hash

    @paint_case = PaintCase.new(params[:paint_case])

    if @paint_case.save
      save_pictures
      #redirect_to :action => :edit, :id => @paint_case.id
      flash[:notice] = "案例创建成功!"
      redirect_to paint_admin_paint_cases_path
    else
      @paint_worker = PaintWorker.find(params[:paint_case][:paint_worker_id]) unless params[:paint_case][:paint_worker_id].blank?
      @painter = Painter.new()
      @painter = @paint_worker.painter if @paint_worker and @paint_worker.painter
      render :action => :new
    end

  end
  
  def edit
    @paint_worker = @paint_case.paint_worker if @paint_case.paint_worker
    @painter = Painter.new()
    @painter = @paint_worker.painter if @paint_worker and @paint_worker.painter

    if @paint_case.wood_construction_specifications.blank?
      @wcs = [WoodConstructionSpecification.new(),WoodConstructionSpecification.new()]
    else
      @wcs = @paint_case.wood_construction_specifications
    end

    if @paint_case.product_specifications.blank?
      @ps = [ProductSpecification.new(),ProductSpecification.new()]
    else
      @ps = @paint_case.product_specifications
    end

    @paint_case_pictures = @paint_case.paint_case_pictures
    #@paint_worker = @paint_case.paint_worker ||  PaintWorker.new(:USERNAME=>"没有选择油漆工")
  end

  def update
    @paint_case =  PaintCase.find(params[:id])

    ps_hash = params[:paint_case]["product_specifications_attributes"]
    params[:paint_case]["product_specifications_attributes"].map do |ps|
      @ps = ProductSpecification.new(ps[1])
      unless @ps.valid?
        ps_hash.delete(ps[0])
        ProductSpecification.find(ps[1]["id"]).destroy if ps[1]["id"]
      end
    end
    params[:paint_case]["product_specifications_attributes"] = ps_hash

    wcs_hash = params[:paint_case]["wood_construction_specifications_attributes"]
    params[:paint_case]["wood_construction_specifications_attributes"].map do |wcs|
      @wcs = WoodConstructionSpecification.new(wcs[1])
      unless @wcs.valid?
        wcs_hash.delete(wcs[0])
        WoodConstructionSpecification.find(wcs[1]["id"]).destroy if wcs[1]["id"]
      end
    end
    params[:paint_case]["wood_construction_specifications_attributes"] = wcs_hash

    if @paint_case.update_attributes(params[:paint_case])
      save_pictures
      flash[:notice] = "案例修改成功!"
      #redirect_to :action => :edit, :id => @paint_case.id
      redirect_to paint_admin_paint_cases_path
    else
      render :action => :edit
    end
  end
  
  def do
      selected = params[:select]
      status = case params[:do]
      when "审核" ; 1
      when "取消审核" ; 0
      when "删除" ; -1
      when "彻底删除" ; -2
      end
      PaintCase.update_all("status = #{status}",["id in (?)",selected])
    
      selected.each do |c|
        paint_case = PaintCase.find c
        paint_worker = paint_case.paint_worker
        unless paint_worker.blank?
          skill_score = paint_worker.paint_cases.status_is(1).average('skill_score').to_i
          service_score = paint_worker.paint_cases.status_is(1).average('service_score').to_i
          paint_worker.painter.update_attributes({:skill_score => skill_score, :service_score => service_score})
        end
      end
      puts PaintCase::SHOW_STATUS.index(status)
      render :json =>{"status" => PaintCase::SHOW_STATUS.index(status) }
    end
  
    def save
      its_id = params[:id]
      params[:paint_case][:status] = 0 if params[:status].to_i == 0
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

      ps_hash = params[:paint_case]["product_specifications_attributes"]
      params[:paint_case]["product_specifications_attributes"].map do |ps|
        @ps = ProductSpecification.new(ps[1])
        ps_hash.delete(ps[0]) unless @ps.valid?
      end
      params[:paint_case]["product_specifications_attributes"] = ps_hash

      wcs_hash = params[:paint_case]["wood_construction_specifications_attributes"]
      params[:paint_case]["wood_construction_specifications_attributes"].map do |wcs|
        @wcs = WoodConstructionSpecification.new(wcs[1])
        wcs_hash.delete(wcs[0]) unless @wcs.valid?
      end
      params[:paint_case]["wood_construction_specifications_attributes"] = wcs_hash

      @paint_case = its_id.blank? ? PaintCase.new(params[:paint_case]) : PaintCase.find(params[:id])
      if its_id.blank? ? @paint_case.save : @paint_case.update_attributes(params[:paint_case])
        save_pictures
        render :json => {"time" =>"保存于 #{Time.now.to_s(:db)}" , "id" => @paint_case.id }.to_json
      else
        render :nothing => true
      end
    end
  
    def set_essence
      @paint_case.update_attribute(:essence , !@paint_case.essence )
      render :text => @paint_case.essence
    end
  
    def delete_picture
      @picture = Picture.find(params[:id])
      @picture.destroy
      render :nothing => true
    end
  
    def destroy
      @paint_case=PaintCase.find(params[:id])
      @paint_case.destroy
      redirect_to :action => :index
    end


    ## 油工搜索
    def search_paint_workers
      @paint_workers = []
      painter_name = CGI::unescape(params[:painter_name].strip)
      unless params[:painter_name].blank?
        @paint_workers = PaintWorker.by_all({}).find(:all, :conditions => ["HEJIA_USER_BBS.USERBBSNAME like ?","%#{painter_name}%"])
      end
      render :partial => 'search_paint_workers', :locals => {:painter_name => painter_name, :paint_workers => @paint_workers}
    end

    def pictures_sort
      list_index = 999
      order_array = params[:pictures]
      order_array.each do |id|
        PaintCasePicture.update_all("list_index = #{list_index}",:id => id) if params[:pictures]
        list_index -= 1
      end
      render :nothing => true
    end
  
    private

    def save_pictures
      list_index = 999
      unless params[:pictures].nil?
        params[:pictures].each do |picture|
          name = picture.values_at("name")[0]
          picture.delete("name")
          if @picture = Picture.find_by_image_id(picture[:image_id])
            @picture.update_attributes(picture)
            pcp = PaintCasePicture.find(:first, :conditions => ["paint_case_id = ? and picture_id = ?", @paint_case.id, @picture.id])
            pcp.name = name
            pcp.save
          else
            @picture = Picture.new(picture)
            @picture.item = @paint_case
            @picture.save

            PaintCasePicture.create(:paint_case => @paint_case, :picture => @picture, :list_index => list_index, :name => name)
            list_index -= 1
          end
        end
        master_picture_image_id = params[:pictures][0][:is_master]
        Picture.update_all("is_master = 0 ",["item_type = 'PaintCase' and item_id = ?",@paint_case.id])
        Picture.update_all("is_master = 1 ",:image_id => master_picture_image_id)
      end
    end

    def find_paint_case
      @paint_case = PaintCase.find(params[:id])
    end
  
  end
