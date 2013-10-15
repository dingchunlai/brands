module PaintArticlesHelper

  #得到文章标签
  def get_article_keyword keyword
    keyword
  end
  
  #得到上一篇文章
  def get_previous_article article
    id = Article.page_article(article)[0]
    unless id.nil?
      previous = Article.get_article(id)
      unless previous.nil?
        "上一篇：<a href='#{get_article_url(previous.id)}' target='_self' title='#{previous.title}'>#{truncate(previous.title,:length => 20 ,:omission => '')}</a>"
      end
    end
  end

   #得到下一篇文章
  def get_next_article article
    id = Article.page_article(article)[1]
    unless id.nil?
      next_article  = Article.get_article(id)
      unless next_article.nil?
        "下一篇：<a href='#{get_article_url(next_article.id)}' target='_self' title='#{next_article.title}'>#{truncate(next_article.title,:length => 20 ,:omission => '')}</a>"
      end
    end
  end
  
  #给文章图片加入进入下一页的链接
  def set_article_img content
    
  end
  
  #品牌库产品推荐图库url
  def get_production_info_url id
    "http://youqituliao.51hejia.com/dulux/production/#{id}"
  end
  
    #品牌库产品推荐图库图片
  def production_master_picture(production)
    if RAILS_ENV == 'development'
      'http://d.51hejia.com/api/images/none.gif'
    else
       if production && production.master_picture
        production.master_picture.public_filename
       else
       'http://d.51hejia.com/api/images/none.gif'
      end
    end
   end

end
