class ZhuantiController < ApplicationController
  def index
    @columes = PublishColumn.find(55698,55699,55700,55701,55702,55703)
    unless params[:column_id].blank?
      @contents = PublishContent::valid_contents(params[:column_id]).paginate(:page => params[:page], :per_page => 36)
    else
      @contents = PublishContent::zhuanti_valid_contents.paginate(:page => params[:page], :per_page => 36)
    end
  end
end
