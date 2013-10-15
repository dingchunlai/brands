class Dianping::Firm::EventsController < Dianping::ApplicationController

  before_filter :validates_dianping_with_subdomain

  def index
    @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
     @firm = DecoFirm.published.find(params[:firm_id], :include => :events)
    unless fragment_exist? @fragment_key
      @factories =  @firm.events.paginate(:all,:page => params["page"], :per_page => 20,:order => "created_at desc")
    end
  end

end