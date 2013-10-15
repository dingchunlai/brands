class Admin::CommentsController < AdminController

  def index
    @title = params[:title]
    conditions = []
    conditions << "title like '%#{@title}%'" unless @title.blank?
    @comments = Comment.paginate(:all, :conditions=>conditions.join(" and "), :per_page=>15, :page=>page)
    #render :layout => false
  end

  def destroy
    ids = [params[:id], params[:ids]].join(",").strip.split(",")
    ids.each do |id|
      Comment.destroy(id)
    end
    redirect_to admin_comments_path + (params[:page].to_i>1 ? "?page=#{params[:page]}" : "")
  end


end
