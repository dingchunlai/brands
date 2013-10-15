class Dianping::Firm::FactoriesController < Dianping::ApplicationController

  before_filter :validates_dianping_with_subdomain

  def index
    @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
    @firm = DecoFirm.published.find(params[:firm_id], :include => [:factories])
    unless fragment_exist? @fragment_key
      @factories =  @firm.factories.paginate(:all, :order => 'LIST_INDEX desc,STARTENABLE desc', :page => params["page"], :per_page => 20)
    end
  end

end