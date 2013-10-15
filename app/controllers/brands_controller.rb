# encoding: utf-8
# 品牌首页 url: http://:TAGURL.51hejia.com/:permalink
# 二级品牌首页 url: http://:TAGURL.51hejia.com/:category_url/:permalink
class BrandsController < AutoExpireController

  before_filter BrandValidationFilter, :except => [:series]
  before_filter :get_browsed_productions, :except => [:rate, :ajax_get, :ajax_post, :vote]
  before_filter :set_browsed_productions, :only => [:production,:category_production]
  before_filter :brand_index_page_adspace, :except => [:rate, :ajax_get, :ajax_post, :vote]
  before_filter :validates_rating, :only => [:rate,:categroy_for_rate],:if =>:is_hejia_ip
  before_filter :validates_vote, :only => [:vote]
  before_filter :find_detail, :only => [:show, :info, :production, :productions,:second_category_show,:category_info,:category_productions,:category_production]
  before_filter :find_logo, :only => [:show, :info, :production, :productions,:second_category_show,:category_info,:category_productions,:category_production]
  before_filter :find_rating,:except =>[:second_category_show,:second_category_show_copy,:categroy_for_rate,:category_info,:category_articles,:category_productions,:category_production,:linnei]
  before_filter :get_category_to_id,:only =>[:categroy_for_rate,:second_category_show,:second_category_show_copy,:category_info,:category_articles,:category_productions,:category_production,:linnei]
  before_filter :valide_tag_and_production_category,:only =>[:second_category_show,:category_info,:category_articles,:category_productions,:category_production,:linnei]
  before_filter :get_categroy_rating,:only =>[:categroy_for_rate,:second_category_show,:second_category_show_copy,:category_info,:category_articles,:category_productions,:category_production,:linnei]
  before_filter :init_page, :only => [:show, :info, :production, :productions, :comments, :articles, :documents, :show_commen, :show_comment,:second_category_show,:category_info,:category_articles,:category_productions,:category_production]
  before_filter :set_title_keyword_descript_for_category,:only =>[:second_category_show,:category_info,:category_articles,:category_productions,:category_production]
  skip_before_filter :verify_authenticity_token, :only => [:rate, :ajax_post, :vote]

  layout :select_layout_by_template
  include ApplicationHelper
  # 品牌首页
  def show
    #@combination_case = ProductionCombination.first(:conditions => ["tag_id = ? and brand_id = ?",  @tag.TAGID,  @brand.id], :include => :master_picture)
    @combination_cases = ProductionCombination.all(:conditions => ["tag_id = ? and brand_id = ?",  @tag.TAGID,  @brand.id], :include => :master_picture)
    if @brand.part_render_type('单品推荐') > 0
      products_limit = (@brand.part_render_type('单品推荐') == 1) ? 3 : 9
      products_limit = 100 if @brand.name_zh == "林内"
      @products = ProductionPromotionInfo.get_production_promotions(products_limit, "brand_index_priority", @tag.TAGID, @brand.id)
    end
    @questions = Brand.get_questions_answers(@brand)
    @brand.increase_pv!(@tag.TAGID)
    send @tagged_brand.template || "show_v1"
  end

  ## http://chufangdianqi.51hejia.com/haier/haier.swf
  def haier
    render :layout => false
  end

  # 含二级分类的品牌首页
  def second_category_show
    @combination_case = ProductionCombination.first(:conditions => ["tag_id = ? and brand_id = ?",  @tag.TAGID,  @brand.id], :include => :master_picture)
    if @brand.part_render_type('单品推荐') > 0
      products_limit = (@brand.part_render_type('单品推荐') == 1) ? 3 : 9
      @products = ProductionPromotionInfo.get_production_promotions(products_limit, "brand_index_priority", @tag.TAGID, @brand.id,@p_category_id)
    end
    @questions = Brand.get_questions_answers(@brand,@category.name)
    @middle_adspace_page = "#{@tag.TAGNAME}#{@brand.name_zh}#{@category.name}专区-中部通栏"
    promotion_info = ArticlePromotionInfo.all(:conditions => ['brand_index_priority = 1 and brand_id = ?', @brand.id])
    @new_info = Article.of(@tag.TAGID, @brand.id).new_info.first(2)
    @hot_news = Article.of(@tag.TAGID, @brand.id).pince_daogou_info.first(:conditions => ['HEJIA_ARTICLE.ID in (?)', promotion_info.map(&:article_id)], :include => {:article_promotion_info => :picture})
    @pince_daogou_info = Article.of(@tag.TAGID, @brand.id).production_find(@p_category_id).pince_daogou_info.first(7) - [@hot_news]
    render 'show_v1', :layout => "brands/show_v1"
  end

  # 含二级分类的品牌首页----保留一份
  def second_category_show_copy
    @middle_adspace_page = "#{@tag.TAGNAME}#{@brand.name_zh}#{@category.name}专区-中部通栏"
    if params[:permalink] == "linnei"
      render :linnei, :layout => "brands/second_category"
      #render "linnei"
    else
      render :layout => 'brands/second_category'
    end
  end
  
  def linnei
    @middle_adspace_page = "#{@tag.TAGNAME}#{@brand.name_zh}#{@category.name}专区-中部通栏"
    render :layout => 'brands/second_category'
  end


  # 品牌评测导购页面
  def articles
    @articles  = Article.of(@tag.TAGID, @brand.id).pince_daogou_info.paginate :page => page, :per_page => 10
  end

  # 品牌信息页面
  def info
    @attr = BrandDetail::DETAIL_ATTR[params[:item]] && params[:item] || 'description'
  end

  def category_info
    info
    render 'info'
  end
  def category_articles
    @articles  = Article.of(@tag.TAGID, @brand.id).production_find(@p_category_id).pince_daogou_info.paginate :page => page, :per_page => 10
    render 'articles'
  end
  def category_productions
    @order = %w(desc asc).include?(params[:order]) && params[:order] || 'desc'
    cd1, cd2 = ["is_valid = 1"], []
    cd1 << "category_id = ?"
    cd2 << @category.id
    conditions = [cd1.join(" and ")].concat(cd2)
    @productions = Production.of_brand_tag(@brand.id, @tag.TAGID).paginate :page => page, :per_page => 15, :conditions => conditions, :order => ' id ' + @order
    @production_category = Production.production_categorys(@brand.id, @tag.TAGID)
    render 'productions'
  end

  def category_production
    @promotion_items['广告'] ||= {}
    @promotion_items['广告']['页头通栏'] = API_PROMOTION_MAPPING['广告']['页头通栏']['产品终端页']

    @production = Production.find(params[:id])
    @production_category = @category
    render 'production'
  end

  # 品牌点评列表页
  def comments
    @type = params[:type] || 'all'
    @comment_tag = params[:tag]
    @comments = Comment.try("#{@type}_comments", @tagged_brand.id, nil)
    @comments = @comments.for_tag(@comment_tag, nil) unless @comment_tag.blank?
    @comments = @comments.paginate(:per_page => 15, :page => page)
    render :layout =>  "brands/#{@tagged_brand.template}"
  end

  # 品牌点评终端页
  def show_comment
    #Rails.cache.clear
    @comment = Comment.find(params[:id])
    @previous_comment = @comment.previous_comment
    @next_comment = @comment.next_comment
    @reverts = @comment.comments
    render :layout =>  "brands/#{@tagged_brand.template}"
  end

  # 品牌相关产品列表页面
  def productions
    # 排序方式 || 防止恶意修改
    @order = %w(desc asc).include?(params[:order]) && params[:order] || 'desc'
    cd1, cd2 = ["is_valid = 1"], []
    if params[:category]
      @category_id = params[:category]
      @category = ProductionCategory.find_by_id @category_id
      if @category
        cd1 << "category_id = ?"
        cd2 << @category_id
      end
    end
    conditions = [cd1.join(" and ")].concat(cd2)
    @productions = Production.of_brand_tag(@brand.id, @tag.TAGID).paginate :page => page, :per_page => 15, :conditions => conditions, :order => ' updated_at ' + @order
    @production_category = Production.production_categorys(@brand.id, @tag.TAGID)
  end

  # 产品信息页面
  def production
    # TODO 写一个类似inject_promotion_items的方法（或者增强该方法），
    # 实现广告代码方便的加载
    @promotion_items['广告'] ||= {}
    @promotion_items['广告']['页头通栏'] = API_PROMOTION_MAPPING['广告']['页头通栏']['产品终端页']

    @production = Production.find(params[:id])
    @production_category = Production.production_categorys(@brand.id, @tag.TAGID)
  end

  # 资料下载页面
  def documents
  end
  

  # 取得某个品牌下的所有产品系列
  def series
    respond_to do |format|
      format.json { render :json => Brand.find(params[:id]).production_series }
    end
  end

  # 给某品牌评价
  def rate
    @item  = BrandRating.validate_rating_item params[:item]
    if @item
      @brand_rating.increment! @item
      expire_fragment cache_name_for_current_brand('show')
    end
    render :partial => true, :content_type => Mime::JS
  end

  def categroy_for_rate
    @item  = BrandRating.validate_rating_item params[:item]
    can_add = false
    if "58.246.26.58" == request.remote_ip
      can_add = true
    else
      if ["good","soso","bad"].include?(@item)
        key = "BrandRating_#{@brand_rating.id}"
      else
        key = "BrandRating_#{@brand_rating.id}_#{@item.split("_")[0]}"
      end
      
      if cookies[key].blank?
        can_add = true
        cookies[key] = {:value => request.remote_ip, :expires => 12.hours.from_now, :domain => ".51hejia.com"}
      end
    end

    if can_add
      if @item
        @brand_rating.increment! @item
        expire_fragment cache_name_for_current_brand('show')
      end
      render :partial => true, :content_type => Mime::JS
    else
      render :text => false, :content_type => Mime::JS
    end
    
  end

  # 给某品牌投票
  # return type 页面元素的ID
  # rerurn is_success 标识是否投票成功 1 => 成功, 0 => 失败
  def vote
    # 对所投票项目加1
    @tagged_brand.vote_for(params[:poll])
    type = "#"
    type.concat params[:poll]
    render :json => {:message => '感谢您的参与 ! ', :type => type, :is_success => 1}
  end


  # 专门给ajax get来调用
  # 根据参数t来决定调用哪个具体的方法
  def ajax_get
    
    #send params[:t]
    # GET 显示form
=begin
    if cookies['ind_id'].blank?
      session['user:user:id'] = nil
    else
      session['user:user:id'] = cookies['ind_id']
    end

    if user_logged_in?
      render :partial => 'comment'
    else
      render :partial => "shared/ajax_login"
    end
=end
    if cookies['ind_id'].blank?
      render :partial => "shared/ajax_login"
    else
      render :partial => 'comment'
    end
    headers['Cache-Control'] = 'no-cache'
  end

  # 专门给ajax post来调用
  # 根据参数t来决定调用哪个具体的方法
  def ajax_post
    #send params[:t]
    # POST 保存信息
    # 保持与render :json => comment.erros格式保持一致
    if cookies['ind_id'].blank?
      session['user:user:id'] = nil
    else
      session['user:user:id'] = cookies['ind_id']
    end
    return render :json => [['authentication', '评论前请先登录。']], :status => :forbidden unless user_logged_in?

    comment = Comment.create(params[:comment])
    comment.ip = request.remote_ip
    comment.user_id = cookies['ind_id']

    if comment.save
      render :json => comment.to_json(:only => [:id, :title])
    else
      render :json => comment.errors, :status => 500
    end
  end

  private
  #调用模板1（品牌终端页）
  def show_v1
    promotion_info = ArticlePromotionInfo.all(:conditions => ['brand_index_priority = 1 and brand_id = ?', @brand.id])
    @new_info = Article.of(@tag.TAGID, @brand.id).new_info.first(2)
    @hot_news = Article.of(@tag.TAGID, @brand.id).pince_daogou_info.first(:conditions => ['HEJIA_ARTICLE.ID in (?)', promotion_info.map(&:article_id)], :include => {:article_promotion_info => :picture})
    @pince_daogou_info = Article.of(@tag.TAGID, @brand.id).pince_daogou_info.first(7) - [@hot_news]
    render :show_v1, :layout => "brands/show_v1"
  end

  #调用模板2（品牌终端页）
  def show_v2
    @bbs_tag = BbsTag.find(:first,:select=>"id",:conditions=>["brand_id=? and brand_tag_id=?", @brand.id, @tag.TAGID])
    @pince_daogou_info = ArticlePromotionInfo.articles_by_brand(@brand.id, 6)
    render :show_v2, :layout => 'brands/show_v2'
  end

  # 用户填写评论的form。
  # 会先判断用户是否已经登录，如果没有登录，先显示登录（注册）form
  def comment
    if cookies['ind_id'].blank?
      session['user:user:id'] = nil
    else
      session['user:user:id'] = cookies['ind_id']
    end
    
    if request.post?
      # POST 保存信息
      # 保持与render :json => comment.erros格式保持一致
      return render :json => [['authentication', '评论前请先登录。']], :status => :forbidden unless user_logged_in?

      comment = Comment.create(params[:comment])
      comment.ip = request.remote_ip
      comment.user = current_user

      if comment.save
        render :json => comment.to_json(:only => [:id, :title])
      else
        render :json => comment.errors, :status => 500
      end
    else
      # GET 显示form
      if user_logged_in?
        render :partial => 'comment'
      else
        render :partial => "shared/ajax_login"
      end
    end
  end

  #保存网友印象
  def save_impression
    impression = Impression.new :title => params[:title], :tagged_brand_id => @tagged_brand.id
    if impression.save
      render :json => Impression.latest(@tagged_brand.id)
    else
      render :json => impression.errors.full_messages, :status => 500
    end
  end

  def login_form
    render :partial => "shared/ajax_login"
  end

  #保存点评回复
  def comment_revert
    if user_logged_in?
      comment = Comment.find(params[:comment_id]).comments.build
      comment.tagged_brand_id = @tagged_brand.id
      comment.title = 'post'
      comment.body = params[:body]
      comment.ip = request.remote_ip
      comment.user = current_user
      if comment.save
        render :json => comment.to_json(:only => [:id, :title])
      else
        render :json => comment.errors, :status => 500
      end
    else
      render :json => 'unlogged', :status => :forbidden
    end
  end

  #点评的鸡蛋与鲜花操作
  def comment_vote
    cache_key = "comment_vote/#{request.ip}/#{@tag.TAGURL}/#{@brand.permalink}/#{params[:comment_id]}"
    count = 0
    unless Rails.cache.read(cache_key)
      comment = Comment.find(params[:comment_id])
      count = comment.comment_vote(params[:type]) #点评投票(鲜花or鸡蛋)
      Rails.cache.write cache_key, true, :expires_in => 1.day
    end
    render :text => count.to_s
  end

  # 投诉
  def complain
    if request.get?
      render :partial => "complain"
    else
      create_model "complain"
    end
  end

  # 加盟
  def franchisee
    if request.get?
      render :partial => "franchisee"
    else
      create_model "franchisee"
    end
  end
  
  # 保存投诉或者加盟的数据
  def create_model(model_name)
    model = model_name.classify.constantize.new(params[model_name])
    model.save
    render :json => {:message => '感谢您的参与 ! '}
  end

  # 取得以往浏览过的产品记录
  # 浏览过的产品是记录在cookie里面的
  def get_browsed_productions
    if browsed_productions = cookies[:browsed_productions]
      @browsed_productions = Production.all(:conditions => ['id in (?)', browsed_productions.split(',').map(&:to_i)], :include => :master_picture)
    end
    true
  end

  # 保存浏览过的产品记录
  def set_browsed_productions
    id = params[:id]
    return unless id
    id = id.to_i
    browsed_productions = (cookies[:browsed_productions] || '').split(',').map(&:to_i)
    browsed_productions.delete id
    browsed_productions.unshift id
    browsed_productions = browsed_productions[0...5] # 只保存最新的五次浏览记录
    cookies[:browsed_productions] = browsed_productions.join(',')
    true
  end
  
  # 根据品牌和品类得到对应的 DETAIL 
  def find_detail
    @brand_detail = @brand.detail_for(@tag)
  end
  # 根据品牌和品类得到对应的 LOGO
  def find_logo
    @brand_logo   = @brand.logos.detect   { |logo|   logo.tag_id   == @tag.TAGID }
  end
  
  # 根据品牌和品类得到对应的 RATING
  def find_rating
    @brand_rating = @brand.rating_for(@tag)
  end

  # 防止恶意投票。
  def validates_rating
    item = params[:item]
    # 归类投票
    if %w(good soso bad).include?(item)
      item = 'good_or_bad' 
    else
      # 其他都是像service_good或者service_bad的形式，取前面的service作为归类
      item = item.split('_').first
    end
    # 限制到每个品类/品牌的每一种投票
    cache_key = "rating_memo/#{request.ip}/#{@tag.TAGURL}/#{@brand.permalink}/#{item}"
    if Rails.cache.read(cache_key)
      render :text => "感谢您的参与，但您已经参与过这个投票了。\n(注：24小时内，同一个项目仅能进行一次有效的投票)", :status => 403
    else
      Rails.cache.write cache_key, true, :expires_in => 1.day
    end
  end
  
  # 防止用户恶意投票
  # 效仿上面的方法
  def validates_vote
    cache_key = "brand_vote/#{request.ip}/#{@tagged_brand.id}/#{@brand.permalink}"
    if Rails.cache.read(cache_key)
      type = "#"
      type.concat params[:poll]
      render :json => {:message => "感谢您的参与，但您已经参与过此投票了。\n(注：24小时内，只能进行一次有效的投票)", :type => type, :is_success => 0}
    else
      Rails.cache.write cache_key, true, :expires_in => 1.day
    end
  end

  # 根据当前的品牌，得到cache的名称
  def cache_name_for_current_brand(action)
    "#{@tag.TAGURL}/#{@brand.permalink}/#{action}"
  end
  helper_method :cache_name_for_current_brand

  def select_layout_by_template
    "brands/#{@tagged_brand.template}"
  end

  def init_page
    @promotion_page = PromotionPage.find_by_name "品牌首页"
  end

  def get_categroy_rating
    @brand_rating = @brand.rating_for_category(@category)
  end

  def is_hejia_ip
    !['58.246.26.58','127.0.0.1'].include? request.ip
  end

  def valide_tag_and_production_category
    unless ProductionCategory.find(:all,:conditions => ["tag_id =?",@tag.TAGID]).map(&:id).include? @p_category_id.to_i
      return head 404
    else
      @brand_category = BrandsProductionCategory.find_by_brand_id_and_production_category_id @brand.id, @p_category_id.to_i
      if @brand_category.blank? || !@brand_category.online
        return head 404
      end
    end
  end

  def get_category_to_id
    @category = ProductionCategory.find_by_id params[:category_id] if params[:category_id]
    @category = ProductionCategory.find(:first,:conditions => ["category_url = ? and tag_id = ?",params[:category_url],@tag.TAGID]) if params[:category_url]
    if @category
      @p_category_id = @category.id
    else
      return head 404
    end
  end

  def set_title_keyword_descript_for_category
    set_page_meta_data('品类','家电',"#{@brand.name_zh}#{@category.name}")
  end

  def brand_index_page_adspace
    @brand_index_page_adspace, @second_adspace_page = "品牌库-品牌首页", "品牌库-品牌首页"
  end
end
