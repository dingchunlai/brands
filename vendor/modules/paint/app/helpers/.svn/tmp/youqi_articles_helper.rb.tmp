module YouqiArticlesHelper

  #得到文章标签
  def get_article_keyword keyword
    keyword
  end
  
  #得到上一篇文章
  def get_previous_article article
    id = Article.youqi_page_article(article)[0]
    unless id.nil?
      previous = Article.get_article(id)
      unless previous.nil?
        "上一篇：<a href='#{previous.detail_url}' target='_self' title='#{previous.title}'>#{truncate(previous.title,:length => 20 ,:omission => '')}</a>"
      end
    end
  end

   #得到下一篇文章
  def get_next_article article
    id = Article.youqi_page_article(article)[1]
    unless id.nil?
      next_article  = Article.get_article(id)
      unless next_article.nil?
        "下一篇：<a href='#{next_article.detail_url}' target='_self' title='#{next_article.title}'>#{truncate(next_article.title,:length => 20 ,:omission => '')}</a>"
      end
    end
  end

end
