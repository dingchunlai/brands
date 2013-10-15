
require_dependency 'coupon/admin_controller'
class Admin::CouponFaqsController < Coupon::AdminController
  load_and_authorize_resource
  
  def index
    @question = params[:question]
    @group = params[:group].to_i
    @coupon_faqs = CouponFaq.with_group(@group).with_question(@question).paginate(:include => [:faq_group], :page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @coupon_faq = CouponFaq.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @coupon_faq = CouponFaq.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @coupon_faq = CouponFaq.find(params[:id])
  end

  def create
    @coupon_faq = CouponFaq.new(params[:coupon_faq])

    respond_to do |format|
      if @coupon_faq.save
        flash[:notice] = 'Q&A 创建成功.'
        format.html { redirect_to(admin_coupon_faqs_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @coupon_faq = CouponFaq.find(params[:id])

    respond_to do |format|
      if @coupon_faq.update_attributes(params[:coupon_faq])
        flash[:notice] = ' Q&A 修改成功 .'
        format.html { redirect_to(admin_coupon_faq_path(@coupon_faq)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @coupon_faq = CouponFaq.find(params[:id])
    @coupon_faq.hide
    respond_to do |format|
      format.html { redirect_to(admin_coupon_faqs_path) }
    end
  end


  def group
    @faq_groups = FaqGroup.all
  end

  def create_group
    attributes = params[:attributes]
    fail_name = ""
    attributes.each do |_, name|
      unless name.blank?
        faq = FaqGroup.find_by_name name
        if faq.blank?
          FaqGroup.create!(:name => name)
        else
          fail_name.concat name
          fail_name.concat " "
        end
      end
    end
    unless fail_name.blank?
      flash[:alert] = " #{fail_name} 分类已经存在 ."
    else
      flash[:notice] = "添加成功"
    end
    redirect_to request.env["HTTP_REFERER"]
  end

  def update_group
    if request.xhr?
      @faq_group = FaqGroup.find params[:id]
      @faq_group.update_attribute :name, params[:name]
      render :json => @faq_group 
    end
  end

  def delete_group
    faq_group = FaqGroup.find params[:id]
    faq_group.destroy
    redirect_to request.env["HTTP_REFERER"]
  end

end
