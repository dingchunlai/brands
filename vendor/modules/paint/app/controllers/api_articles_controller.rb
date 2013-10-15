class ApiArticlesController < PaintApplicationController 
#  helper CloudFsHelper
  
  def gongyi
    
  end
  
  def shigonggongju
    
  end
  
  def peixun
    @id = params[:id]
  end
  
  def show
    id = params[:id]
    @article = Article.get_article(id)
    @youqi = @article.KEYWORD1.include?("墙面漆") ? "墙面漆" : "木器漆"
    content = @article.content.CONTENT
    content = content.gsub("[swf]", "<embed src='")
    content = content.gsub("[/swf]", "' quality='high' width='480' height='400' align='middle' allowScriptAccess='allways' mode='transparent' type='application/x-shockwave-flash'></embed>")
    content = content.gsub("src=\"/UserFiles/Image", "src=\"http://image.51hejia.com/UserFiles/Image")
    content = content.gsub("src=\"/images/binary", "src=\"http://image.51hejia.com/images/binary")
    article_pages = content.split("{==PAGE-BREAK==}")
    @article_page = article_pages.paginate :page => params[:page], :per_page => 1
  end
  
end