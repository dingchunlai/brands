class Dianping::Firm::DesignersController < Dianping::ApplicationController
  
  before_filter :validates_dianping_with_subdomain

  def index
    @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
     @firm = DecoFirm.published.find params[:firm_id]
    unless fragment_exist? @fragment_key
      @designers = CaseDesigner.firm_case_designer(@firm.id).paginate(:per_page => 20, :page => params[:page])
    end
  end

end