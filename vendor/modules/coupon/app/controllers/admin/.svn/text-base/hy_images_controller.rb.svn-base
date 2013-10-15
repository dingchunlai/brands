require_dependency 'coupon/admin_controller'

class Admin::HyImagesController < Coupon::AdminController
  def index
    authorize! :manage_hy_images, :distributors
    @images = Distributor::UploadPicture.unaudited.paginate(
        :page => ((params[:page].to_i==0)? 1 : params[:page].to_i),
        :per_page => 20
    )
    respond_to do |format|
      format.html { }
    end
  end

  def aduit
    authorize! :manage_hy_images, :distributors
    @image = Distributor::UploadPicture.find(params[:id])
    respond_to do |format|
      if @image.update_attribute("approval_status", true)
        format.html { redirect_to :back }
      else
        format.html { redirect_to :back }
      end
    end
  end
end