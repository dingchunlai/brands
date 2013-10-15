# encoding: utf-8

require_dependency 'coupon/admin_controller'
class Admin::PrintRecordsController < Coupon::AdminController
  
  load_and_authorize_resource
  before_filter :validate_print_record, :only => [:tag, :destroy_tag, :edit_tag, :preview, :print, :cancel]

  def index
    @city = params[:city]
    @print_records = PrintRecord.with_city(@city).paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)
    authorize! :read, PrintRecord 

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @print_record = PrintRecord.find(params[:id])
    authorize! :read, @print_record

    @tag_amount = TagAmount.new

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @print_record = PrintRecord.new
    authorize! :create, @print_record

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @print_record = PrintRecord.find(params[:id])
    authorize! :update, @print_record
  end

  def create
    @print_record = PrintRecord.new(params[:print_record])
    authorize! :create, @print_record

    respond_to do |format|
      if @print_record.save
        flash[:notice] = '打印信息创建成功.'
        format.html { redirect_to(admin_print_records_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @print_record = PrintRecord.find(params[:id])
    authorize! :update, @print_record

    respond_to do |format|
    if @print_record.update_attributes params[:print_record]
        flash[:notice] = '打印信息更新成功.'
        format.html { redirect_to(admin_print_records_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @print_record = PrintRecord.find(params[:id])
    authorize! :destroy, @print_record

    if @print_record.destroy
      flash[:notice] = '打印信息删除成功.'
    else
      flash[:alert] = '打印信息删除失败.'
    end
    respond_to do |format|
      format.html { redirect_to(admin_print_records_path) }
    end
  end

  # === 设置关联行业信息 ====
   
  # 创建某印刷信息的关联行业
  def tag
    @tag_amount = TagAmount.new(params[:tag_amount])

    authorize! :tag, TagAmount
    @tag_amount.save 
    render :action => :show
  end

  # 打印记录与所有行业批量关联
  def tag_all
    authorize! :print, PrintRecord
    print_record = PrintRecord.find(params[:id])
    tagids = Industry.all_categories.map(&:TAGID)
    tagids.each do |tid|
      coupons_count_by_tag = Coupon.count(:conditions => ["tag_id = ? and city_id = ? ", tid, print_record.city_obj.id])
      TagAmount.create!( :tag_id => tid, :amount => coupons_count_by_tag, :print_record_id => print_record.id )
    end
    js_code =<<-CODE
      <script type="text/javascript">
        alert("已经绑定所有行业\\n\\n点[确定]转到打印信息页.");
        location.href= '#{admin_print_record_path(print_record)}';
      </script>
    CODE
    render :text => js_code
  end

  # 删除某一个印刷信息中的行业信息
  def destroy_tag
    unless params[:tag_amount_id].blank?
      tag_amount = TagAmount.find_by_id params[:tag_amount_id]     

      authorize! :destroy_tag, tag_amount 
      unless tag_amount.blank?
        @print_record.tag_amounts.destroy(tag_amount)
        @print_record.save
      end
      redirect_to admin_print_record_path(@print_record) 
    else
      redirect_to admin_print_records_path
    end
  end

  # 打印预览页面
  def preview
    authorize! :preview, PrintRecord
  end

  # 打印
  def print
    authorize! :print, PrintRecord
    
    unless @print_record.tag_amounts.blank?
      @print_record.tag_amounts.each_with_index do |tag_amount, index|
        coupons = Coupon.with_tag_city(tag_amount.tag.TAGID, @print_record.city_obj.id, tag_amount.amount)
        coupons.each do |coupon|
          CouponsPrintRecord.create(:coupon => coupon, :print_record => @print_record)
        end
      end
      Resque::Job.create :coupon_images, "Coupon::ImageGenerator::Job::Print", @print_record.id
    end
    redirect_to admin_print_record_path(@print_record)
  end
  
  # 退出打印
  def cancel
    authorize! :cancel, PrintRecord
    redirect_to admin_print_record_path(@print_record)
  end

  # === end ===

  # 验证在设置行业关联的时，是否已经确定印刷月份信息
  def validate_print_record
    unless params[:id].blank?
      @print_record = PrintRecord.find params[:id]
    else
      redirect_to admin_print_records_path
    end
  end
  private :validate_print_record

end
