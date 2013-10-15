class Dianping::Firm::DecorationDiariesController < Dianping::ApplicationController

  before_filter :validates_dianping_with_subdomain

  def index
    @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
    @firm = DecoFirm.published.find(params[:firm_id], :include => :decoration_diaries)
    unless fragment_exist? @fragment_key
      @diaries = @firm.decoration_diaries.published.paginate(:all,:per_page => 10,:page => params[:page],:order => "order_time desc")
    end
  end

end