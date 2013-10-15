# encoding: utf-8
require_dependency 'coupon'
class DistributorUser::GroupImagesController < Coupon::DistributorUserController

  def create
    resource_type = params[:distributor_upload_picture].delete(:pic_type)
    @img_type = resource_type
    resource_id = params[:distributor_upload_picture].delete(:resource_id)
    resource = nil
    model = begin
      if resource_type == "activity"
        VipDistributorActivity
      elsif resource_type == "case"
        VipDistributorCase
      else
        nil
      end
    end
    resource = model.find(:first, :conditions => ["id = ?", resource_id]) if model
    if resource
      if resource.distributor_id != @current_distributor.id
        @image = Distributor::UploadPicture.new
        @image.errors.add_to_base("无权限创建")
        respond_to do |format|
          format.js { }
        end
      else
        @image = resource.pictures.build(params[:distributor_upload_picture].update(:approval_status => true))
        respond_to do |format|
          if @image.save
            resource.reload
            resource.update_attributes(:default_image_id => @image.id) if resource.pictures.size == 1
            @resource = resource
            format.js { }
          else
            format.js { }
          end
        end
      end
    else
      @image = Distributor::UploadPicture.new
      @image.errors.add_to_base("resource does not exist!")
      respond_to do |format|
        format.js { }
      end
    end
  end

  def update
    @image = Distributor::UploadPicture.find(params[:id])
    resource = nil
    model = begin
      if @image.resource_type == "VipDistributorActivity"
        VipDistributorActivity
      elsif @image.resource_type == "VipDistributorCase"
        VipDistributorCase
      else
        nil
      end
    end
    resource = model.find(:first, :conditions => ["id = ?", @image.resource_id]) if model

    if resource
      if resource.distributor_id != @current_distributor.id
        @image.errors.add_to_base("没有操作权限")
        respond_to do |format|
          format.js { }
        end
      else
        respond_to do |format|
          if @image.update_attributes(:image_url => params[:distributor_upload_picture][:image_url], :name => params[:distributor_upload_picture][:name], :summary => params[:distributor_upload_picture][:summary], :approval_status => true)
            format.js {}
          else
            format.js {}
          end
        end
      end
    else
      @image.errors.add_to_base("resource does not exist!")
      respond_to do |format|
        format.js { }
      end
    end
  end

    # 渲染表单
  def render_form
    @img_type = (params[:type] if %w(case activity).include? params[:type]) || "activity"
    @resource_id = params[:resource_id]
    if params[:id]
      @image = Distributor::UploadPicture.find(params[:id])
    else
      @image = Distributor::UploadPicture.new
    end
    respond_to do |format|
      format.js { render :partial => "form" }
    end
  end

  def set_default
    @image = Distributor::UploadPicture.find(params[:id])
    resource = nil
    model = begin
      if @image.resource_type == "VipDistributorActivity"
        VipDistributorActivity
      elsif @image.resource_type == "VipDistributorCase"
        VipDistributorCase
      else
        nil
      end
    end

    resource = model.find(:first, :conditions => ["id = ?", @image.resource_id]) if model

    if resource
      if resource.distributor_id == @current_distributor.id
        resource.update_attributes(:default_image_id => @image.id)
        redirect_to request.headers["HTTP_REFERER"], :notice => "默认图片设置成功!"
      else
        raise CanCan::AccessDenied
      end
    else
      raise CanCan::AccessDenied
    end
  end

end