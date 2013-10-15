module ApiArticlesHelper
  
  def top_location(id)
    if id.nil?
      ["培训认证体系",nil]
    elsif id.to_i == 1
      ["<a href='/peixun' target='_self' title='培训认证体系'>培训认证体系</a>","油工的选择"]
    elsif id.to_i == 2
      ["<a href='/peixun' target='_self' title='培训认证体系'>培训认证体系</a>","油工与特殊工艺"]
    elsif id.to_i == 3
      ["<a href='/peixun' target='_self' title='培训认证体系'>培训认证体系</a>","油工培训和认证"]
    else
      ["培训认证体系",nil]
    end
  end
  
  def articles_for_gongyi_api 
     hejia_promotion_items(API_SHIGONG_GONGYI, :attributes => ['url','title'],:limit => 6)
  end
  
  
  
  #得到上一篇文章
  def last_article_gongyi article_id
    articles = articles_for_gongyi_api
    articles_index = articles.map{|article| article.url } 
    unless articles_index.index(article_id.to_s) == 0
      last_article = articles[articles_index.index(article_id.to_s) - 1]
      "上一篇：<a href='#{gongyi_url(last_article.url)}' target='_self' title='#{last_article.title}'>#{truncate(last_article.title,:length => 20 ,:omission => '')}</a>"
    end
  end

   #得到下一篇文章
  def next_article_gongyi article_id
    articles = articles_for_gongyi_api
    articles_index = articles.map{|article| article.url } 
    if articles_index.index(article_id.to_s) + 1 < articles.size
      next_article = articles[articles_index.index(article_id.to_s) + 1]
      "下一篇：<a href='#{gongyi_url(next_article.url)}' target='_self' title='#{next_article.title}'>#{truncate(next_article.title,:length => 20 ,:omission => '')}</a>"
    end
  end
  
end