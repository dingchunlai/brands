# encoding: utf-8

class Api::ArticlesController < Api::BaseController
  def create
    article_param = params[:article]
    content = article_param.delete :content

    article = Article.new article_param
    article.save!
    content = ArticleContent.new :CONTENT => content
    content.save!
    article.update_attribute :CONTENTID, content.id

    render :json => {:id => article.id}
  end
end
