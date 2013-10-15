require_dependency 'coupon/admin_controller'
class Admin::ComplaintsController < Coupon::AdminController

  load_and_authorize_resource

  # GET /complaints
  # GET /complaints.xml
  def index
    page = params[:page].to_i
    page = 1 if page == 0
    @complaints = Complaint.search(params).paginate(:all, :page => page, :per_page => 20, :include => :coupon)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @complaints }
    end
  end

  # GET /complaints/1
  # GET /complaints/1.xml
  def show
    @complaint = Complaint.find(params[:id], :include => :coupon)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @complaint.to_json }
    end
  end

  # GET /complaints/new
  # GET /complaints/new.xml
  def new
    @complaint = Complaint.new
    coupon = Coupon.find(params[:coupon_id]) if params[:coupon_id]
    if coupon
      @complaint.coupon_id = coupon.id
      @complaint.coupon_code = coupon.code
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @complaint }
    end
  end

  # GET /complaints/1/edit
  def edit
    @complaint = Complaint.find(params[:id], :include => :coupon)
  end

  # POST /complaints
  # POST /complaints.xml
  def create
    @complaint = Complaint.new(params[:complaint])

    respond_to do |format|
      if @complaint.save
        format.html { redirect_to(admin_complaints_path) }
#        format.html { redirect_to(@complaint, :notice => 'Complaint was successfully created.') }
        format.xml { render :xml => @complaint, :status => :created, :location => @complaint }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @complaint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /complaints/1
  # PUT /complaints/1.xml
  def update
    @complaint = Complaint.find(params[:id])

    respond_to do |format|
      if @complaint.update_attributes(params[:complaint])
        format.html { redirect_to(admin_complaints_path) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @complaint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /complaints/1
  # DELETE /complaints/1.xml
  def destroy
    @complaint = Complaint.find(params[:id])
    @complaint.mark_deleted

    respond_to do |format|
      format.html { redirect_to(admin_complaints_path) }
      format.xml { head :ok }
    end
  end

  # 需求..:( 应分别创建ACTION 若要任务运行 最好还是调用COUPON的方法（既 COUPON中创建处理方法）
  def confirm
    #1.nil to true or false
    # a. nil to true :complaints_count + 1
    # 2. true to false
    # a.nil to true :complaints_count - 1
    # 3. false to true ???!!!

    if request.xml_http_request?
      begin
        @result = "confirm failure"
        @complaint = Complaint.find(params[:id])
        old_status = @complaint.is_valid

        if old_status.nil?
          if @complaint.update_attributes(:is_valid => (params[:status] == "true") ? true : false)
            if @complaint.is_valid?
              # 降权--调用
              coupon = @complaint.coupon
              coupon.confirm_complaint
            end
            @result = "success"
          else
            @result = "confirm failure"
          end
        elsif old_status == true
          if params[:status] == "true"
            @result = "success"
          else
            if @complaint.update_attributes(:is_valid => false)
              unless @complaint.is_valid?
                # reset权重--调用
                coupon = @complaint.coupon
                coupon.revocation_complaint
              end
              @result = "success"
            else
              @result = "confirm failture"
            end
          end
        elsif old_status == false
          # ???
          @result = "success"
        end
      rescue
        @result = "exception raise"
      end
    else
      @result = "only for ajax"
    end
    render :text => @result
  end

end
