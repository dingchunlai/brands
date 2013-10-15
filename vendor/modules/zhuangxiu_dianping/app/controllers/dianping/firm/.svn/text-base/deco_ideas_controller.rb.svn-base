class Dianping::Firm::DecoIdeasController < Dianping::ApplicationController

  before_filter :validates_dianping_with_subdomain

  def index
     @fragment_key = "dianping:firm:#{params[:firm_id]}:#{controller_name}:#{params[:page]}"
     @firm = DecoFirm.published.find(params[:firm_id], :include => :deco_ideas)
     unless fragment_exist? @fragment_key
       @deco_ideas = @firm.deco_ideas.paginate(:all,:per_page => 10,:page => params[:page],:order => "updated_at desc")
     end
    end

end