class Dianping::Firm::ConstructionPhotosController < Dianping::ApplicationController

  before_filter :validates_dianping_with_subdomain

  def index
    @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
    @firm = DecoFirm.published.find(params[:firm_id], :include => :photos)
    unless fragment_exist? @fragment_key
      @photos = @firm.photos.paginate(:all, :page=>params[:page], :per_page => 28)
    end
  end

end