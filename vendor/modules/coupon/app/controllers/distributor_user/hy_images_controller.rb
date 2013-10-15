# encoding: utf-8
require_dependency 'coupon'
class DistributorUser::HyImagesController < Coupon::DistributorUserController
  def index
    @img_type = (params[:type] if %w(shop case glory).include? params[:type]) || "shop"
    types = @current_distributor.pictypes.find(:all, :conditions => ["class_name = ?", "Distributor::PictureType::#{@img_type.titleize}"], :include => :pictures)
    @images = Distributor::UploadPicture.paginate(:all,
      :conditions => ["resource_id in (?)", types.map(&:id)],
      :per_page => 10,
      :page => ((params[:page].to_i==0)? 1 : params[:page].to_i)
    )
    
    respond_to do |format|
      format.html {  }
    end
  end

  def update
    @image = Distributor::UploadPicture.find(params[:id])
    type = Distributor::PictureType.find(@image.resource_id)
    if type.distributor_id != @current_distributor.id
      @image.errors.add_to_base("您没有权限操作此图片")
      respond_to do |format|
        format.js { }
      end
    else
      respond_to do |format|
        if @image.update_attributes(:image_url => params[:distributor_upload_picture][:image_url], :name => params[:distributor_upload_picture][:name], :approval_status => false)
          format.js { }
        else
          format.js { }
        end
      end
    end
  end

  def create
    @img_type = params[:distributor_upload_picture].delete(:pic_type)
    types = @current_distributor.pictypes.find(:all, :conditions => ["class_name = ?", "Distributor::PictureType::#{@img_type.titleize}"], :include => :pictures)
    @images = types.inject([]) { |ary, type| ary.concat(type.pictures) }

    @remove_add_link = false
    if @images.size >= Distributor::HY_PIC_UPLOAD_LIMIT[@img_type.to_sym]
      @remove_add_link = true
      @image = Distributor::UploadPicture.new
      @image.errors.add_to_base("已达到可上传数量限值")
      respond_to do |format|
        format.js { }
      end
    else
      @type = Distributor::PictureType.new(:class_name => "Distributor::PictureType::#{@img_type.titleize}", :distributor_id => @current_distributor.id)
      @type.save
      @image = @type.pictures.build(params[:distributor_upload_picture])
      respond_to do |format|
        if @image.save
          format.js { }
        else
          format.js { }
        end
      end
    end
  end

  # 渲染表单
  def render_form
    @img_type = (params[:type] if %w(shop case glory).include? params[:type]) || "shop"
    if params[:id]
      @image = Distributor::UploadPicture.find(params[:id])
    else
      @image = Distributor::UploadPicture.new
    end
    respond_to do |format|
      format.js { render :partial => "form" }
    end
  end
end