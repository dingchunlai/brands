class Dianping::Firm::CasesController < Dianping::ApplicationController
  
  before_filter :validates_dianping_with_subdomain

  def index
    @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
    @firm = DecoFirm.published.find(params[:firm_id])
    unless fragment_exist? @fragment_key
      @home_cases = @firm.cases.paginate(:all, :per_page => 28,:conditions => "category = 0 and EXISTS (select * FROM photo_photos as p WHERE p.case_id = HEJIA_CASE.ID)" ,:page => params[:page])
      @office_cases = @firm.cases.paginate(:all, :per_page => 28,:conditions => "category = 1 and EXISTS (select * FROM photo_photos as p WHERE p.case_id = HEJIA_CASE.ID)" ,:page => params[:page])
    end
  end

end