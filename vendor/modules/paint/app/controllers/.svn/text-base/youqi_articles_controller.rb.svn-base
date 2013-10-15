class YouqiArticlesController < PaintApplicationController 
    before_filter :validate_article,  :only => [:show] 
  def index
    @location = "油漆工知识"
    @articles = PaintKeywordArticle::articles.paginate :page => params[:page], :per_page => 7
  end
  
  #终端页
  def show
    @location = "油漆工知识"
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