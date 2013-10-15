class ArticlesCell < ApplicationCell

  def this_week_top10
    render
  end

  # 资讯TOP5
  def zixun_top5
    @hangye = hejia_promotion_items(54783, :attributes => ['title','url'])
    @zhuangxiu = hejia_promotion_items(54784, :attributes => ['title','url'])
    @chanpin = hejia_promotion_items(54785, :attributes => ['title','url'])
    @zhuangshi = hejia_promotion_items(54788, :attributes => ['title','url'])
    render
  end

  def for_brands
    @articles = ArticleSort.find_by_name('品牌库').articles
    render
  end

end
