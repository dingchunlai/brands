# 文章推广后台
class AdminV2::ArticlesController < AdminV2Controller
  # search article_promotion_info
  # params[:brand_name] 品牌名称
  # params[:title]  文章标题
  # params[:brand] 品牌类型
  # return articles
  def index
    articles = Article
    unless params[:brand_name].blank?
      brand =  Brand.find(:first, :conditions => ["name_zh = ?",params[:brand_name]])
      articles =  articles.with_brand(brand)  if brand
    end
    articles = articles.with_title(params[:title]) unless params[:title].blank?
    articles = articles.with_type(params[:brand]) unless params[:brand].blank?
    @articles = articles.paginate :conditions => ["FIRSTCATEGORY = ?",Tag.father_id], 
            :include => [:tag, {:brand_link => :brand}, {:article_promotion_info => :picture}],
            :page => page,
            :per_page => 30 
  end
  # update or create    article_promotion_info
  # params[:id] 关联的推广文章编号
  # params[:shouye_index] 标识为品牌库首页推广
  # params[:pinlei_index] 标识为品类首页推广
  # params[:pinpai_index] 标识为品牌首页推广 && params[:brand_id]  关联的品牌 && params[:pictrue] 关联的推广图片
  # return 
  def update
    article_promotion = ArticlePromotionInfo.find(:first, :conditions => ["article_id = ?", params[:id]])
    article_promotion = ArticlePromotionInfo.new :article_id => params[:id] unless article_promotion
    article_promotion.index_priority          = params[:shouye_box] && params[:shouye_index].to_i || nil
    article_promotion.category_index_priority = params[:pinlei_box] && params[:pinlei_index].to_i || nil
    logger.info '-' * 80
    logger.info article_promotion.category_index_priority.inspect
    if params[:pinpai_box] && params[:brand_id].to_i != 0
      article_promotion.brand_index_priority = params[:pinpai_index].to_i
      article_promotion.brand_id = params[:brand_id].to_i
    else
      article_promotion.brand_index_priority = nil
      article_promotion.brand_id = nil
    end
    if article_promotion.index_priority.nil? && article_promotion.category_index_priority.nil? && article_promotion.brand_index_priority.nil?
      article_promotion.destroy
      flash[:notice] = '推广信息更新成功！'
    else
      unless (picture = params[:article] && params[:article][:picture]).blank?
        article_promotion.picture.destroy if article_promotion.picture
        article_promotion.picture = ProductPicture.new :uploaded_data => picture
      end
      if article_promotion.save
        flash[:notice] = '推广信息更新成功！'
        logger.info '2'
        logger.info article_promotion.category_index_priority.inspect
      else
        flash[:alert] = '推广信息更新失败！'
      end
    end
    redirect_to :back
  end
end
