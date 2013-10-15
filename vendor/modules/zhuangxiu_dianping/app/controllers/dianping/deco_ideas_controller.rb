class Dianping::DecoIdeasController < Dianping::ApplicationController

  before_filter :vaildates_dianping_zhongduan_with_subdomain, :only => [:show]
  
  def show
    @deco_idea = DecoIdea.find(params[:id], :include => [:deco_firm, {:deco_firm => :deco_ideas}, :remarks])
    @firm = @deco_idea.deco_firm
    @remarks = @deco_idea.remarks.paginate(:all, :per_page => 10, :page => params[:page])
    unless fragment_exist? "dianping:firm:deco_idea:show:#{@deco_idea.id}:bottom"
      @previous_deco_idea = @firm.deco_ideas.find(:first,:conditions=>["created_at < ?", @deco_idea.created_at],:order =>"created_at desc")
      @next_deco_idea = @firm.deco_ideas.find(:first,:conditions=>["created_at > ?", @deco_idea.created_at],:order =>"created_at")
    end
  end
  
end