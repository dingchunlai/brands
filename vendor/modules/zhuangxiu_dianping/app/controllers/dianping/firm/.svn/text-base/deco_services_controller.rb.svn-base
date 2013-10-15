class Dianping::Firm::DecoServicesController < Dianping::ApplicationController

  before_filter :validates_dianping_with_subdomain

  def index
     @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
     @firm = DecoFirm.published.find(params[:firm_id], :include => :deco_services)
     unless fragment_exist? @fragment_key
       @deco_services = @firm.deco_services.paginate(:all,:per_page => 10,:page => params[:page],:order => "updated_at desc")
     end
    end

end