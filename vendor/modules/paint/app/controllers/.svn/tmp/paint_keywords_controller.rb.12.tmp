class PaintKeywordsController < PaintApplicationController
  def show
    @location = "<a href='/articles' title='油漆工知识'>油漆工知识</a>"
    @paint_keyword = PaintKeyword.find(params[:id])
    @articles = @paint_keyword.articles.paginate :page => params[:page], :per_page => 7
  end
end