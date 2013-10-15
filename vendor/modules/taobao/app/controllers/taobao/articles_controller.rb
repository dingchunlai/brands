class Taobao::ArticlesController < Taobao::ApplicationController

  def index
    @keyword_id = params[:keyword_id]
  #  @articles = TaobaoArticle.keyword_id_eq(@keyword_id).paginate(:page => params[:page],:per_page => 10,:order => "entity_created_at desc")
  @articles = Article.paginate(
    :all,
    :select => "ID,FIRSTCATEGORY,SECONDORDERID,CREATETIME,IMAGENAME,TITLE,SUMMARY,CREATETIME",
    :conditions => {:FIRSTCATEGORY => params[:keyword_id]},
    :order => " CREATETIME DESC",
    :page => params[:page],
    :per_page => 10
    )
    
    @pictures = hejia_promotion_items(54108, :attributes => ['image_url','title','url'],:limit => 10)[4,4]
    @top_articles = hejia_promotion_items(230, :attributes => ['title','url'],:limit => 8)
    @hot_topics = hejia_promotion_items(114, :attributes => ['image_url','title','url'],:limit => 2)
  end
  
  def show
    @keyword_id = params[:keyword_id]
    @article = Article.find(params[:id])
    @pre_article = TaobaoArticle.keyword_id_eq(@keyword_id).find(:first,:conditions => ["entity_created_at < ?",@article.CREATETIME],:order => "entity_created_at desc")
    @next_article = TaobaoArticle.keyword_id_eq(@keyword_id).find(:first,:conditions => ["entity_created_at > ?",@article.CREATETIME],:order => "entity_created_at")
    @pro_articles = hejia_promotion_items(54053, :attributes => ['title','url'],:limit => 60)[50,10]
    @focus =   hejia_promotion_items(49, :attributes => ['image_url','title','url'],:limit => 4)
    @deco_infos = hejia_promotion_items(54060, :attributes => ['title','url'],:limit => 8)
    @jiajus = hejia_promotion_items(55267, :attributes => ['image_url','title','url'],:limit => 2)
    @kongjian = hejia_promotion_items(53398, :attributes => ['image_url','title','url'],:limit => 2)
    @daogou = hejia_promotion_items(54271, :attributes => ['image_url','title','url'],:limit => 5)
    @hudong = hejia_promotion_items(55046, :attributes => ['image_url','title','url'],:limit => 5)
  end
  
private


  

end