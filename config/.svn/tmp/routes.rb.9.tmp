ActionController::Routing::SEPARATORS <<  "-" unless ActionController::Routing::SEPARATORS.include?("-")
ActionController::Routing::Routes.draw do |map|

  # http://zt.51hejia.com/
  map.with_options :conditions => {:subdomain => 'zt'} do |zt|
    zt.root :controller => 'zhuanti', :action => 'index'
  end

  # http://deco.51hejia.com/
  map.with_options :conditions => {:subdomain => 'deco'} do |deco|
    deco.root :controller => 'deco', :action => 'index'
  end

  # http://prod.51hejia.com/
  map.with_options :conditions => {:subdomain => 'prod'} do |prod|
    prod.root :controller => 'prod', :action => 'index'
  end

  map.with_options :conditions => {:subdomain => /life\.taobao/} do |t|
    t.taobao_articles "taobao/:keyword_id", :controller => "taobao/articles", :action => "index"
    t.taobao_article "taobao/:keyword_id/:id", :controller => "taobao/articles", :action => "show"
  end

  map.remote 'remote/:t/:id', :controller => 'remote', :action => 'ajax_get', :id => nil

  # 新版文章终端页
  map.with_options :conditions => {:subdomain => /^(d|www)$/} do |article|
    article.connect ':channel/:date/:id', :controller => "articles", :action => "detail", :requirements => { :date => /20\d{4,6}/, :id => /\d{4,9}(_preview)?/ }
    article.connect ':channel/:date/:id-:page', :controller => "articles", :action => "detail", :requirements => { :date => /20\d{4,6}/, :id => /\d{4,9}(_preview)?/, :page => /(\d+|all)/ }
    article.connect 'article_keywords.js', :controller => "articles", :action => "article_keywords"
    article.connect 'record_dynamic', :controller => "articles", :action => "record_dynamic"
    article.connect ':channel/:date/:id/get_cities', :controller => "articles", :action => "get_cities", :requirements => { :date => /20\d{4,6}/, :id => /\d{4,9}(_preview)?/ }
    article.connect ':channel/:date/:id/get_districts', :controller => "articles", :action => "get_districts", :requirements => { :date => /20\d{4,6}/, :id => /\d{4,9}(_preview)?/ }
    article.connect '/get_cities', :controller => "articles", :action => "get_cities"
    article.connect '/get_districts', :controller => "articles", :action => "get_districts"
  end


  # 新版装修点评
  map.connect 'user/:action', :controller => "user"

  map.connect '/users/reg_save' , :controller => "index", :action =>'reg_save'

  
  map.with_options :conditions => {:subdomain => /daren/} do |daren|
    daren.root :controller => 'dianping/zhuan_ti', :action => 'super_man_game'
  end

  map.with_options :conditions => {:subdomain => 'api2'} do |api2|
    api2.namespace 'api' do |api|
      api.resources :articles, :only => [:create]
      api.connect 'ajax/:action', :controller => "ajax"
    end
  end

  map.with_options :conditions => {:subdomain => /\Az\.\w+/} do |z|
    
    #公司列表页
    
    z.firms_order_page "/companies-:condition-:order-:page/" , :controller => 'dianping/firms' ,:action => "index" #翻页路由
    z.connect 'coupon/coupon_downloads/send_sms', :controller =>"coupon_downloads", :action =>"send_sms"
    z.firms_order "/companies-:condition-:order/" , :controller => 'dianping/firms' ,:action => "index"  #列表带参数 
    z.firms_page "/companies-:page/" , :controller => 'dianping/firms' ,:action => "index"#翻页路由
    z.firms "/companies/" , :controller => 'dianping/firms' ,:action => "index" #列表
    
    z.villa_page "/villa-:page/", :controller => "dianping/firms", :action => 'bieshu' #别墅翻页
    z.villa "/villa/", :controller => "dianping/firms", :action => 'bieshu' #别墅

    z.decoration_page "/decoration-:page/", :controller => "dianping/firms", :action => 'gongzhuang' #工装翻页
    z.decoration "/decoration/", :controller => "dianping/firms", :action => 'gongzhuang' #工装
    
    z.company_decoration_page "/company_decoration-:page/", :controller => "dianping/firms", :action => 'gongzhuang' #工装翻页
    z.company_decoration "/company_decoration/", :controller => "dianping/firms", :action => 'gongzhuang' #工装
    
   
    
    #日记列表页
    z.decoration_diaries_order_page "/stories-:condition-:order-:page/" , :controller => 'dianping/decoration_diaries', :action => "index" #翻页路由
    z.decoration_diaries_order "/stories-:condition-:order/", :controller => 'dianping/decoration_diaries', :action => "index" #列表带参数 
    z.decoration_diaries_page "/stories-:page/", :controller => 'dianping/decoration_diaries', :action => "index"  #翻页路由
    z.decoration_diaries "/stories/", :controller => 'dianping/decoration_diaries', :action => "index" #列表
    z.decoration_diaries_vote "/decoration_diaries/to_vote_for_me", :controller => 'dianping/decoration_diaries', :action => "to_vote_for_me" # 投票
    z.connect 'decoration_diaries/:action', :controller => "dianping/decoration_diaries"
    
    #案例图片列表页
    z.cases_order_page "/cases-:condition-:page/" , :controller => 'dianping/cases', :action => "index" #翻页路由
    # z.cases_order "/cases-:condition/", :controller => 'dianping/cases', :action => "index" #列表带参数 
    z.cases_page "/cases-:page/", :controller => 'dianping/cases', :action => "index"  #翻页路由
    z.cases "/cases/", :controller => 'dianping/cases', :action => "index" #列表
    
    z.cases_diaries_page "/lists-:page/",:controller => 'dianping/cases_and_decoration_diaries', :action => "index" #翻页路由
    z.cases_diaries "/lists/",:controller => 'dianping/cases_and_decoration_diaries', :action => "index" #翻页路由

    
    #施工图片列表页
    z.construction_photos_page "/gallaries-:page/", :controller => 'dianping/construction_photos', :action => "index"#翻页路由
    z.construction_photos "/gallaries/", :controller => 'dianping/construction_photos', :action => "index"#列表
    
    #排行榜 
    z.top "/rank/", :controller => "dianping/top", :action =>"index"
    
    #优惠券 (搜索没改)
    z.coupons_page '/coupons-:page/' ,:controller => "dianping/coupons" ,:action => "index"#翻页路由
    z.coupons '/coupons/' ,:controller => "dianping/coupons" ,:action => "index"#列表

    #在建工地 (搜索没改)
    z.building_sites_page '/ongoing-:page/' ,:controller => "dianping/factories" ,:action => "index"#翻页路由
    z.building_sites '/ongoing/' ,:controller => "dianping/factories" ,:action => "index"#列表

    #日记终端页
    z.decoration_diary "/stories/:id",:controller => "dianping/decoration_diaries", :action => "show" 
    #案例终端页
    z.case "/cases/:id", :controller => 'dianping/cases', :action => "show"
    
    #优惠券
    z.coupon "/vouchers/:id", :controller => "dianping/coupons" ,:action => "show"
    z.new_coupon "/:firmid/vouchers/:id", :controller => "dianping/coupons" ,:action => "show"
    z.firm_coupon "/coupons/:id", :controller => "dianping/coupons" ,:action => "coupon"
    
    #设计理念
    z.deco_idea '/ideas/:id', :controller => "dianping/deco_ideas", :action => "show"

    ## 服务承诺
    z.deco_service '/services/:id', :controller => "dianping/deco_services", :action => "show"

    z.connect '/designers/new_case_remark', :controller => 'dianping/designers', :action => "new_case_remark"
    #设计师
    z.designer '/designers/:id', :controller => 'dianping/designers', :action => "show"
    
    #一个公司下面的列表页
    
    z.firm_decoration_diaries_page '/:firm_id/stories-:page/', :controller => 'dianping/firm/decoration_diaries', :action => "index"  #日记
    z.firm_decoration_diaries '/:firm_id/stories/', :controller => 'dianping/firm/decoration_diaries', :action => "index"  #日记
    z.firm_cases "/:firm_id/cases/", :controller => 'dianping/firm/cases', :action => "index" #案例
    z.firm_construction_photos '/:firm_id/gallaries/', :controller => 'dianping/firm/construction_photos', :action => "index"#施工图片
    z.firm_factories '/:firm_id/ongoing/', :controller => 'dianping/firm/factories', :action => "index" #在建工地
    z.firm_designers '/:firm_id/designers/', :controller => 'dianping/firm/designers', :action => "index" #设计师
    z.firm_deco_ideas '/:firm_id/ideas', :controller => 'dianping/firm/deco_ideas', :action => "index" #设计理念
    z.firm_deco_services '/:firm_id/services', :controller => 'dianping/firm/deco_services', :action => "index" #服务承诺

   
    #装修公司页面 放最下面
    z.firm "/:id/" , :controller => 'dianping/firms', :action => "show", :id => /[0-9]\d*/

    #点评首页 表单提交
    z.dianping_form_save '/form_save',:controller => 'dianping/home',:action =>'dianping_form_save'
    
    #************ ****************************************************************************************************************#
    z.stat 'stat/:action/:id.gif', :controller => "stat"
    z.connect 'user_sessions/:action', :controller =>"user_sessions"
    z.root :controller => 'dianping/home'
    # z.connect 'remarks/pop_form', :controller =>"dianping/remarks",:action =>""
    z.for_static '/for_static', :controller => 'dianping/home', :action => 'index'
    z.resources :remarks, :controller => "dianping/remarks", :collection => [:pop_form]
     
    z.case_up 'cases-:id/up', :controller => 'dianping/cases', :action => "up", :method => "post"
    z.case_down 'cases-:id/down', :controller => 'dianping/cases', :action => "down", :method => "post"
    z.downcase 'anli/down_case/:id', :controller => 'dianping/cases', :action => "downcase", :method => "get"
      
    z.save_deco_impression 'firms/save_deco_impression' ,:controller => 'dianping/firms', :action => "save_deco_impression", :path_prefix => "dianping"
    z.deco_impression 'firms/deco_impression' ,:controller => 'dianping/firms', :action => "deco_impression"#, :path_prefix => "dianping"
    z.top_deco_impression 'firms/top_deco_impression' ,:controller => 'dianping/firms', :action => "top_deco_impression"#, :path_prefix => "dianping"
    z.deco_impression_cloud_pop 'firms/deco_impression_cloud_pop', :controller => 'dianping/firms', :action => :deco_impression_cloud_pop
      
    z.namespace :dianping do |d|
      # 在线预约装修公司
      d.resources :applicants, :only => [:create,:new], :path_prefix => "dianping"
      # 在线申请在建工地
      d.resources :deco_registers, :only => [:create, :new], :collection => "new_iframe", :path_prefix => "dianping"
    end

    #免费贷款
    map.connect '/free_loan-:page/', :controller => 'dianping/firms', :action => 'free_loan'
    map.connect '/free_loan/', :controller => 'dianping/firms', :action => 'free_loan'

    
    #专题/专访
    z.theme_page '/theme/page/:page', :controller => 'dianping/theme', :action => "index"
    z.theme '/theme', :controller => 'dianping/theme', :action => "index"
    z.dp_interview '/interview', :controller => 'dianping/theme', :action => "interview"

    #【小天书】菜鸟装修快速通道
    z.with_options :controller =>'dianping/zhuan_ti' do |zt|
      zt.fitment '/fitment',:action =>'fitment'
      zt.arranged '/fitment/arranged',:action =>'arranged'
      zt.waterandelectricity '/fitment/waterandelectricity',:action =>'waterandelectricity'
      zt.earthwork '/fitment/earthwork',:action =>'earthwork'
      zt.paint '/fitment/paint',:action =>'paint'
      zt.ending '/fitment/ending',:action =>'ending'
      zt.furniture '/fitment/furniture',:action =>'furniture'
    end
   
  end

  map.remarks_list "dianping/remarks/:action", :controller => "dianping/remarks"

  # http://b.51hejia.com/
  map.with_options :conditions => {:subdomain => false} do |b|
    b.connect '/users/get_image_code', :controller => "index", :action => 'get_image_code', :conditions => {:method => :get}
    b.reg_save '/users/reg_save' , :controller => "index", :action =>'reg_save'

    # 新版文章终端页
    b.connect ':channel/:date/:id', :controller => "articles", :action => "detail", :requirements => { :date => /20\d{4,6}/, :id => /\d{4,9}(_preview)?/ }
    b.connect ':channel/:date/:id-:page', :controller => "articles", :action => "detail", :requirements => { :date => /20\d{4,6}/, :id => /\d{4,9}(_preview)?/, :page => /(\d+|all)/ }
    
    b.zhaoshang 'zhaoshang', :controller => 'huodong', :action => 'zhaoshang'
    b.zhixiao 'zhixiao', :controller => 'huodong', :action => 'zhixiao'
    b.resources :categories, :collection => {:for_tag_and_brand => :get},:controller => 'production_categories', :except => :all,
      :member => { :attrs => :get }
    # “产品系列”，series单复数相同，很难处理，用拼音代替。
    b.resources :chanpinxilie, :singular => :chanpin_xilie, :controller => 'production_series'
    b.resources :brands, :except => :all, :member => { :series => :get }
=begin
    # 旧后台的地址
    b.namespace :admin do |admin|
      admin.root :controller => 'brands', :action => 'index'
      admin.resources :chanpinxilie, :singular => :chanpin_xilie, :controller => 'production_series'
      admin.resources :production_categories
      admin.resources :production_combinations do |c|
        c.resources :pictures, :only => [:index, :new, :create]
      end
      admin.resources(:productions, :member => {:set_is_valid => :get, :save_promotion_info => :put}) do |p|
        p.resources :pictures, :only => [:index, :new, :create]
      end
      admin.resources :pictures, :only => [:destroy], :member => { :set_master => :post }
      admin.resources(:brands,
        :member => {:detail => :get,
          :update_detail => :post,
          :rating        => [:get, :post],
          :display       => :post,
          :hide          => :post,
          :create_bbs => :get,
          :close_bbs => :get,
          :pv_weight => :post,
          :month_pv => :get,
          :attention => :post,
          :update_pv => :post
          }
      ) do |brands|
          brands.resources :documents, :only => [:index, :new, :create]
      end
      admin.resources :documents, :only => [:destroy]
      admin.resources :tags, :only => [:index, :update, :destroy], :member => {:tag_brands => :get, :bbs_tag_save => :post}
      admin.resources :articles
      admin.resources :promotions
      admin.resources :promotion_collections, :collection => {:resource_list => :get, :add_city => :get}
      admin.resources :promotion_items, :path_prefix => '/promition_collection/:code'
      admin.resources :comments
      admin.resources :agencies
      admin.resources :promotion_pages,  :member => {:items => :get, :search_item => :get, :add_item => :post, :edit_item => :post, :modify => :post}
      admin.resources :redirection_addresses, :controller => 'redirection_addresses', :only => [], :collection => {:goto => :get, :back => :get}
    end
=end

    # 新后台的地址
    b.namespace :admin_v2, :name_prefix => 'admin_' do |admin|
      admin.root :controller => 'index', :action => 'index'
      admin.resources :web_permissions, :collection => { :create_permission => :post, :create_group => :post, :update_permission => :post, :fetch_permission => :get }, :except => [:create, :destroy, :edit]
      admin.resources :chanpinxilie, :singular => :chanpin_xilie, :controller => 'production_series'
      admin.resources :production_categories
      admin.resources(:productions, :member => {:set_is_valid => :get, :save_promotion_info => :put}) do |p|
        p.resources :pictures, :only => [:index, :new, :create]
      end
      admin.resources :pictures, :only => [:destroy], :member => { :set_master => :post }
      admin.resources(:brands,
        :member => {:detail => :get,
          :update_detail => :post,
          :rating        => [:get, :post],
          :display       => :post,
          :hide          => :post,
          :create_bbs => :get,
          :close_bbs => :get,
          :pv_weight => :post,
          :month_pv => :get,
          :attention => :post,
          :update_pv => :post,
          :manage => :get,
          :html_meta => :get,
          :update_html_meta => :post,
          :template => [:get, :post],
          :promotion_pages => :get,
          :promotion_page => :get,
          :create_promotion_page => :post,
          :update_promotion_page => :put,
          :promotion_collections_page => :get,
          :impressions => [:get, :post],
          :second_category => :get,
          :display_category => :post,
          :hide_category => :post
        },
        :collection => {
          :search_brands_by_name => :post
        }
      ) do |brands|
        brands.resources :documents, :only => [:index, :new, :create]
        brands.resources :comments, :only => [:index, :destroy, :new, :create, :show]
        brands.resources :agencies
        brands.resources :productions, :only => [:index, :new, :create, :edit, :update, :destroy]
        brands.resources :production_combinations, :only => [:index, :new, :create, :edit, :update, :destroy]  
      end
      admin.contact "/comments/all", :controller => "comments", :action => "all"
      admin.resources :production_combinations do |c|
        c.resources :pictures, :only => [:index, :new, :create]
      end
      admin.resources :documents, :only => [:destroy]
      admin.resources :tags, :only => [:index, :update, :destroy], :member => {:tag_brands => :get, :bbs_tag_save => :post, :manage => :get}
      admin.resources :articles
      admin.resources :promotions
      admin.resources :productions, :only => [:set_is_valid, :save_promotion_info]
      admin.resources :promotion_collections, :collection => {:resource_list => :get, :add_city => :get}
      admin.resources :promotion_items, :path_prefix => '/promition_collection/:code'
      admin.resources :promotion_pages,  :member => {:items => :get, :search_item => :get, :add_item => :post, :edit_item => :post, :modify => :post}
      admin.resources :redirection_addresses, :controller => 'redirection_addresses', :only => [], :collection => {:goto => :get, :back => :get}
      admin.resources :index, :controller => 'index', :only => [:index]
      admin.resources :abilities
    end
    b.articles 'articles', :controller => 'index', :action => 'articles'
    # pinlei是“品类”的拼音，所以没有单复数之分，所以这里采用了在中间加上一个下划线的办法。

    # 个人感觉这个方法还可以，就是在代码中就不太清晰。不过如果规范化了的话，应该
    # 问题不大。谁让拼音没有单复数之分呢？
    b.resources :pinlei, :singular => :pin_lei, :controller => 'categories', :except => :all, :member => { :pinpai => :get }
    b.root :controller => 'index'
  end

  
  # http://www.51hejia.com
  map.with_options :conditions => {:subdomain => 'www'} do |www|
    www.huodong_index  'huodong',            :controller => 'huodong', :action => 'index'
    www.huodong_list   'huodong/list/*args', :controller => 'huodong', :action => 'list'
    www.huodong_detail 'huodong/:id',        :controller => 'huodong', :action => 'detail'
  end

  # http://zt.51hejia.com
  # haier专题
  map.with_options :conditions => {:subdomain => /\Azt\z/} do |zt|
    zt.with_options :namespace => 'haier' do |haier_zt|
      haier_zt.haier_home 'haier', :controller => 'home'
      haier_zt.jzsjs 'haier/jzsjs', :controller => 'designers', :action => 'jzsjs'
      haier_zt.jdsjs 'haier/jdsjs', :controller => 'designers', :action => 'jdsjs'
      haier_zt.qa_1 'haier/jzsjs/qa_1', :controller => 'qa', :action => 'qa_1'
      haier_zt.qa_2 'haier/jzsjs/qa_2', :controller => 'qa', :action => 'qa_2'
      haier_zt.qa_3 'haier/jzsjs/qa_3', :controller => 'qa', :action => 'qa_3'
      haier_zt.qa_4 'haier/jdsjs/qa', :controller => 'qa', :action => 'qa_4'
      haier_zt.haier_yuyue 'haier/jdsjs/yuyue', :controller => 'designers', :action => 'haier_yuyue'
      haier_zt.haier_jzsjs_case 'haier/jzsjs/cases/:id', :controller => 'designers', :action => 'show2'
      haier_zt.haier_jdsjs_case 'haier/jdsjs/cases/:id', :controller => 'designers', :action => 'show1'
      haier_zt.map 'haier/map', :controller => 'opinion', :action => 'view_map'
      haier_zt.up_down '/opinion/:id/up_down/', :controller => 'opinion', :action => 'up_down'

      haier_zt.reshuiqi_diaocha 'haier/reshuiqi/diaocha.html', :controller =>'waterheater', :action =>'solution'
      haier_zt.haier_waterheater_rating 'haier/reshuiqi/diaocha/rating', :controller =>'waterheater', :action =>'rating'
      haier_zt.haier_waterheater_message 'haier/reshuiqi/diaocha/message', :controller =>'waterheater', :action =>'create'
    end

    zt.with_options :namespace => 'dulux', :path_prefix => 'dulux' do |dulux_zt|
      dulux_zt.dulux_color 'color', :controller => 'home', :action => 'color'
    end

  end

  # http://xxx.51hejia.com
  map.with_options :controller => 'brands', :conditions => {:subdomain => true} do |tag|
    tag.pinpai_stat ':permalink/stat.gif', :controller => 'stat', :action => 'brands'
    # 品牌相关的地址
    # --- 开始 ---
    # 某品牌下的某产品详细信息页面
    tag.pinpai_production ':permalink/production/:id', :action => 'production'
    # 某品牌下的产品列表
    tag.pinpai_productions ':permalink/productions', :action => 'productions'
    # 某品牌下的文章列表
    tag.pinpai_articles  ':permalink/articles', :action => 'articles'

    #tag.pinpai_articles  'haier/haier.html', :action => 'haier'

    # 某品牌的资料列表
    tag.pinpai_documents ':permalink/documents', :action => 'documents'
    # 某品牌的信息列表
    tag.pinpai_info ':permalink/info', :action => 'info'
    # 某品牌的点评列表
    tag.pinpai_comments ':permalink/comments', :action => 'comments'
    # 某品牌的点评终端页
    tag.pinpai_show_comment ':permalink/comments/:id', :action => 'show_comment'
    # 给某品牌品类口碑投票
    tag.pinpai_rate ':permalink/rate', :action => 'rate', :conditions => {:method => :post}
    #按品类投票
    tag.categroy_rate ':permalink/categroy_for_rate' ,:action =>'categroy_for_rate',:conditions => {:method => :post}
    # ajax get
    tag.ajax_get ':permalink/ajax_get/:t', :action => 'ajax_get', :conditions => {:method => :get}
    tag.comment ':permalink/comment', :action => 'comment', :conditions => {:method => :get}
    # ajax post
    tag.ajax_post ':permalink/ajax_post/:t', :action => 'ajax_post', :conditions => {:method => :post}

    # 投票
    tag.vote ':permalink/vote/', :action => 'vote', :conditions => {:method => :post}
    # 某品牌首页
    tag.show_pinpai ':permalink', :action => 'show'


    # 二级分类的 品牌首页  行业｜品类｜品牌
    tag.second_category 'c-:category_id/:permalink', :action => 'second_category_show_copy'

    tag.second_category_new ':category_url/:permalink', :action => 'second_category_show'
    tag.second_category_info ':category_url/:permalink/info',:action =>'category_info'
    tag.second_category_articles ':category_url/:permalink/articles',:action =>'category_articles'
    tag.second_category_productions ':category_url/:permalink/productions',:action =>'category_productions'
    tag.second_category_production ':category_url/:permalink/production/:id',:action =>'category_production'
    # --- 结束 ---
    
    # 行业首页
    tag.show_pinlei '/', :controller => 'categories', :action => 'show'
  end
  


  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.

  #map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
  #map.connect 'decoration_diaries/:action', :controller => "dianping/decoration_diaries"
end
