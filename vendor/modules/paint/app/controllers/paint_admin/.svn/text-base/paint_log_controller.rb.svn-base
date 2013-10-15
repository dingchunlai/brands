class PaintAdmin::PaintLogController < PaintAdmin::AdminController
  
   load_and_authorize_resource
  
  def index
    @user_id, @start_date, @end_date = params.values_at(:user_id, :start_date, :end_date)
    @logs = PaintLog.by_all(params).paginate :page => params[:page], :per_page => 30
  end

end