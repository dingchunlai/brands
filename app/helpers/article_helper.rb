module ArticleHelper
  extend ActiveSupport::Memoizable
  # 取得所有的品牌信息
  # params[:articleid] 文章编号
  # params[:category_id]  品类编号
  # return brand  推广文章的品牌信息
  # 暂无用信息
  def get_brand_info(articleid, category_id)
    brands = HejiaArticleLink.all(:conditions => ["articleid = ? and typename = 'brand' and firstid = ?", articleid, category_id])
    Brand.all :conditions => ["id in (?)", brands.map(&:typeid)]
  end
  memoize :get_brand_info
end
