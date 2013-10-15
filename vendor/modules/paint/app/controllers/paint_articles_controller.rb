class PaintArticlesController < PaintApplicationController 
    before_filter :validate_article,  :only => [:show] 
#    skip_filter :auto_expire, :only => [:index, :show]
    #列表页
  def index
    @youqi = params[:youqi]
    @articles = Article.duoleshi(@youqi, nil).paginate :page => params[:page], :per_page => 4
    
#    #把品牌库的图片拿出来
#   多乐士专用
    tag = Tag['youqituliao']
    brand = Brand.of_tag(tag).first :conditions => ['permalink = ?', 'dulux'] 
    @category_id = 17 if @youqi == '墙面漆'
    @category_id = 18 if @youqi == '木器漆'
    cd1, cd2 = ["is_valid = 1"], []
    category = ProductionCategory.find_by_id @category_id
    if category
      cd1 << "category_id = ?"
      cd2 << @category_id
    end
    conditions = [cd1.join(" and ")].concat(cd2)
    @productions = Production.by_create_date.of_brand_tag(brand.id, tag.TAGID).find(:all,:conditions => conditions, :limit => 5, :order => ' id desc')
  end
  
  #终端页
  def show
    @youqi = @article.KEYWORD1.include?("墙面漆") ? "墙面漆" : "木器漆"
    content = @article.content.CONTENT
    content = content.gsub("[swf]", "<embed src='")
    content = content.gsub("[/swf]", "' quality='high' width='480' height='400' align='middle' allowScriptAccess='allways' mode='transparent' type='application/x-shockwave-flash'></embed>")
    content = content.gsub("src=\"/UserFiles/Image", "src=\"http://image.51hejia.com/UserFiles/Image")
    content = content.gsub("src=\"/images/binary", "src=\"http://image.51hejia.com/images/binary")
    article_pages = content.split("{==PAGE-BREAK==}")
    @article_page = article_pages.paginate :page => params[:page], :per_page => 1
  end
  
#  private ---------------------------华丽的分割线---------------------------------------
  private
  def validate_article
    id = params[:id]
    @article = Article.get_article(id)
    
  end
end