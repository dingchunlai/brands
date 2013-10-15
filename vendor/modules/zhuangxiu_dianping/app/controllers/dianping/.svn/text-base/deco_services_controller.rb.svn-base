class Dianping::DecoServicesController < Dianping::ApplicationController

  before_filter :vaildates_dianping_zhongduan_with_subdomain, :only => [:show]

  def show
    @deco_service = DecoService.find(params[:id], :include => [:deco_firm, {:deco_firm => :deco_services}, :remarks])
    @firm = @deco_service.deco_firm
    @remarks = @deco_service.remarks.paginate(:all, :per_page => 10, :page => params[:page])
    unless fragment_exist? "dianping:firm:deco_service:show:#{@deco_service.id}:bottom"
      @previous_deco_service = @firm.deco_services.find(:first,:conditions=>["created_at < ?", @deco_service.created_at],:order =>"created_at desc")
      @next_deco_service = @firm.deco_services.find(:first,:conditions=>["created_at > ?", @deco_service.created_at],:order =>"created_at")
    end
  end

end