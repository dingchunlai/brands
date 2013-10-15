# encoding: utf-8

# coupon_download controller
class CouponDownloadsController < CouponApplicationControllerController

  protect_from_forgery :except => :send_sms

  before_filter :validate_coupon_status, :only => [:new]

  # 下载成功后下载数加1
  after_filter :update_download_count, :only => [:create]
  skip_before_filter :validate_domain, :only => [:send_sms]

  def send_sms
    # 校验手机格式
    unless params[:mobile].to_s =~ /^1[3|5|8]\d{9}$/
      respond_to do |format|
        format.js { render :json => { :status => 1, :msg => '手机格式错误' }.to_json }
      end
      return
    end
    
    if(params[:image_code] != session[:image_code])
      respond_to do |format|
        format.js { render :json => { :status => 2, :msg => '验证码错误' }.to_json }
      end
      return
    end

    if params[:ids]
      result = nil
      begin
        coupon_ids = params[:ids].split(",")
        coupon_ids.each do |coupon_id|
          coupon = Coupon.find(coupon_id)
          coupon_download = coupon.coupon_downloads.new(:mobile => params[:mobile])
          coupon_download.source = ''
          partner = PartnerShip.find(:first, :conditions => ['code = ? and activity_begin_at <= ? and activity_end_at >= ?', cookies["cp_source"], Time.zone.today, Time.zone.today]) if cookies["cp_source"]
          coupon_download.source = partner.code if partner
          if coupon_download.save
            coupon.increase_count!({:key => 'download'})
            Coupon.decrement_counter(:existing_number, coupon.id)
            Coupon.decrement_counter(:virtual_existing_number, coupon.id)
          end
        end
        cookies.delete(:_coupon_downloads, :domain => 'domain.com', :path => '/')
        session[:image_code] = nil
        result = true
      rescue
        result = false
      end
      respond_to do |format|
        format.js {
          if result
            render :json => { :status => 0, :msg => '下载成功' }.to_json
          else
            render :json => { :status => 4, :msg => '处理异常，请联系本站客服.' }.to_json
          end
        }
      end
    else
      respond_to do |format|
        format.js { render :json => { :status => 2, :msg => '未选择现金券' }.to_json }
      end

    end
    
  end

  # 下载页面
  def new
   @coupon_download = CouponDownload.new
  end

  # 下载方法
  def create
    if(params[:image_code] != session[:image_code])
      respond_to do |format|
        format.html { redirect_to(coupon_show_path(params[:coupon_download][:coupon_id])) }
        format.js {
          render :update do |page|
            page << "$('#msg_for_image_code').text('验证码错误');\n$('#msg_for_image_code').addClass('djq_alert');"
          end
        }
      end
      return
    end 

    @coupon = Coupon.find_by_id(params[:coupon_download][:coupon_id])
    @coupon_download = @coupon.coupon_downloads.new(params[:coupon_download])

    @coupon_download.source = ''
    
    @partner = PartnerShip.find(:first, :conditions => ['code = ? and activity_begin_at <= ? and activity_end_at >= ?', cookies["cp_source"], Time.zone.today, Time.zone.today]) if cookies["cp_source"]

    @coupon_download.source = @partner.code if @partner

    if @coupon_download.save
      respond_to do |format|
        format.html { redirect_to(coupon_show_path(params[:coupon_download][:coupon_id])) }
        format.js {}
      end
    else
      respond_to do |format|
        @coupon_download = CouponDownload.new
        @coupon = Coupon.find_by_id(params[:coupon_download][:coupon_id])
        format.html { render :action => :new, :id => params[:coupon_download][:coupon_id] }
        format.js {}
      end
    end
  end

  # 本来下载成功后打开新的页面 后更改为弹出框
  # 于是此方法无用
  def confirm
    @coupon_download = CouponDownload.find_by_id params[:id]
    if @coupon_download.blank?
      redirect_to coupon_index_path
    end
  end
  private :confirm

  def update_download_count
    # 对应的下载记录数加1
    @coupon && @coupon.increase_count!({:key => 'download'})
  end
  private :update_download_count

end
