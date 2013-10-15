class AdminV2::CommentsController < AdminV2Controller
  
  before_filter :validate_tagged_brand, :except => [:all]

  def all
    unless params[:keyword].blank?
      comments = Comment.find(:all,:conditions => ["title like ? or body like ?","%#{params[:keyword]}%","%#{params[:keyword]}%"])
      comments = [] if comments.blank?
    else
      comments =  Comment.all
    end
    @comments = comments.paginate(:per_page => 50, :page=>page)
    render :layout => false
  end
  
  def index
    comments =  Comment
    comments = comments.with_tagged_brand(@tagged_brand.id)
    @comments = comments.paginate(:per_page=>15, :page=>page)
  end

  def destroy
    begin
      ids = [params[:id], params[:ids]].join(",").strip.split(",")
      ids.each do |id|
        Comment.destroy(id)
      end
      flash[:notice] = "删除点评成功 ！"
    rescue
      flash[:alert] = "删除点评失败 ！ "
    end
    redirect_to :back
  end
  
  # 新建品牌评论页面
  def new
    index = HejiaUserBbs.used_user.length 
    @user = HejiaUserBbs.used_user[rand(index)] 
    @comment = Comment.new
  end
  
  def create
    comment = Comment.new(params[:comment])
    unless params[:tags].blank?
      tags =  params[:tags].values
      comment.tags = tags
    end
    comment.ip = request.remote_ip()
    if comment.save
      flash[:notice] = "添加【评论】成功！"
    else
      flash[:alert] = "创建评论信息失败! #{comment.errors.full_messages}"
    end
    redirect_to new_admin_brand_comment_path(@brand, :tag_id => @tag.TAGID)
  end

  # 查看评论信息
  def show
    @comment = Comment.find_by_id params[:id]
  end


end
