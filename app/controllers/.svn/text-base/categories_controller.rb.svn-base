# -*- coding: utf-8 -*-
# 品类首页
class CategoriesController < AutoExpireController
  layout nil

  before_filter :find_and_check_tag, :except => [:pinpai]

  def show
    @products = ProductionPromotionInfo.get_production_promotions(15, "category_index_priority", @tag.TAGID)

    @article_lists = [
      @tag.find_articles('文章列表1'),
      @tag.find_articles('文章列表2'),
      @tag.find_articles('文章列表3')
    ]

    @terminologys    = @tag.find_articles '术语'
    @latest_articles = @tag.find_articles '最新文章'

    inject_promotion_items @promotion_items, '品类', @tag.TAGNAME,
      ['导航栏品牌链接'],
      ['焦点图',         {:include => ['image_url', 'title', 'url'], :limit => 3}],
      ['文字大标题',     {:include => ['description'], :limit => 1}],
      ['文字小标题前缀', {:limit => 4}],
      ['文字小标题',     {:limit => 4}],
      ['最新消息前缀'],
      ['最新消息',   {:limit => 2}],
      ['资讯焦点图', {:include => ['image_url', 'description'], :limit => 1}],
      ['热门专区',   {:limit => 4}],
      ['三张小图',   {:include => ['image_url'], :limit => 3}],
      ['小字部分',   {:limit => 15}], # 5 x 3 = 15
      ['各类专区',   {:include => ['image_url'], :limit => 4}],
      ['品牌Logo区', {:include => ['image_url']}],
      ['宽幅广告1',  {:include => ['image_url'], :limit => 1}],
      ['品牌排行',   {:include => ['price_ago'], :limit => 9}],
      ['经销商促销', {:include => ['image_url', 'price_ago', 'price_now'], :limit => 2}],
      ['宽幅广告2',  {:include => ['image_url'], :limit => 1}],
      ['友情链接']

    @adspace_page = "#{@tag.TAGNAME}-首页"
    @friendly_links = []
    fl_array = [["youqituliao",55024],["chufangdianqi",55025],["diban",55026],["weiyu",55027],["chugui",55028],["diaoding",55114]]
    @friendly_links = hejia_promotion_items(fl_array.assoc(current_subdomain)[1], :attributes => ['url', 'title']) if fl_array.assoc(current_subdomain)
  end

  # 返回所有属于某个品类的品牌
  def pinpai
    brands = Brand.of_tag(params[:id], true)
    respond_to do |format|
      format.json { render :json => brands }
    end
  end

  private
  def find_and_check_tag
    @tag = Tag[current_subdomain]
    head 404 unless @tag
    redirect_to 'http://www.51hejia.com' if @tag.TAGURL == 'jiadian'
  end

  # 根据当前的品牌，得到cache的名称
  def cache_name_for_current_category(action)
    "#{@tag.TAGURL}/#{action}"
  end
  helper_method :cache_name_for_current_category

end
