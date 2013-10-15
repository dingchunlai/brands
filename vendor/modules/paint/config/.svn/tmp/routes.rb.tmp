ActionController::Routing::Routes.draw do |map|
  
  map.with_options :conditions => {:subdomain => 'www.yougong'} do |www|
    www.namespace :paint_admin do |admin|
      admin.root :controller => 'login'
      admin.resources :paint_admins, :collection => [:update_password] , :member => [:edit_password]
      admin.resources :contacts, :collection => [:get_cities]
      admin.resources :paint_workers, :collection => [:applicants, :accept,:recycle,:regain, :overrule, :reset_password] , :member => [:edit_password]
      admin.resources :paint_cases , :collection => [:save,:delete_picture, :do, :search_paint_workers, :pictures_sort] ,:member => [:set_essence]
      admin.resources :mail , :collection => [:update_config, :test_mail]
      admin.paint_log '/log' , :controller => 'paint_log'
      admin.home_page '/home' , :controller => 'home'
      admin.logout '/logout' , :controller => 'login' , :action => 'logout'
      admin.connect '/online/:action', :controller => 'online'
      admin.connect '/export/:action', :controller => 'export_xls'
    end
    
    #判断用户名是否存在
    www.connect '/sessions/validate_username', :controller => 'paint_sessions' ,:action => 'validate_username'
    www.connect '/sessions/validate_phone', :controller => 'paint_sessions' ,:action => 'validate_phone'
    #公用的
    www.public_module '/public/:action', :controller => 'public'
    www.logout '/sessions/login_show', :controller => 'paint_sessions' , :action => 'login_show'
    #暂时屏蔽前台路由
   # www.connect '*path', :controller => 'public', :action => 'jump'
    www.with_options :front_or_backend => "front_end" do |fe|
      fe.root :controller => 'home'
      fe.paint_rating '/paint_rating',:controller => 'home', :action => 'paint_rating'
      fe.connect '/home/help' ,:controller => 'home', :action => 'help'
      fe.paint_workers '/painter/:id', :controller => 'paint_workers'
      fe.connect '/paint_workers/get_paint_cities' ,:controller => 'paint_workers', :action => 'get_paint_cities' 
      fe.connect '/renzhengyougong', :controller => 'paint_workers', :action => 'renzheng'
      fe.connect '/renzhengyougong/all', :controller => 'paint_workers', :action => 'all'
      #油工文章
      fe.paint_articles '/:youqi/articles', :controller => 'paint_articles'
      fe.paint_article '/article/:id', :controller => 'paint_articles' ,:action => 'show'



#      fe.connect '/article/:id/:page', :controller => 'paint_articles' ,:action => 'show'
      fe.connect '/cases', :controller => 'paint_cases'
      fe.connect '/cases/essence', :controller => 'paint_cases', :action => 'essence_case'
      fe.paint_case '/case/:id', :controller => 'paint_cases', :action => 'show'
      fe.connect '/:id/cases/:essence', :controller => 'paint_cases', :action => 'my_cases'
      fe.connect '/:id/cases', :controller => 'paint_cases', :action => 'my_cases'
      
      #服务中心
      fe.connect '/fuwuzhongxin', :controller => 'paint_contacts'
      fe.connect '/chongtu', :controller => 'paint_contacts', :action => 'chongtu'
      fe.connect '/fuwuzhongxin/list', :controller => 'paint_contacts', :action => 'list'
      fe.connect '/paint_contacts/get_contacts_cities' ,:controller => 'paint_contacts', :action => 'get_contacts_cities'
      fe.connect '/paint_contacts/get_cities_duoleshi' ,:controller => 'paint_contacts', :action => 'get_cities_duoleshi'
      #在线派遣
      fe.connect '/paiqian', :controller => 'online', :action => 'send_index'
      fe.paiqian '/paiqian/info', :controller => 'online', :action => 'send_info'
      fe.send_refused '/paiqian/refused', :controller => 'online', :action => 'refused'
      fe.send_create '/paiqian/send_create', :controller => 'online', :action => 'send_create'
      fe.connect '/send/success', :controller => 'online', :action => 'success'
      fe.connect '/training', :controller => 'online', :action => 'training'
      fe.connect '/training/info', :controller => 'online', :action => 'training_info'
      fe.connect '/online/:action', :controller => 'online' 
      #图片
      fe.resources :pictures
      #施工工艺
      fe.connect '/shigonggongyi', :controller => 'api_articles', :action => 'gongyi'
      fe.connect '/shigonggongyi/:id',  :controller => 'api_articles', :action => 'show'
#      fe.connect '/shigonggongyi/:page', :controller => 'paint_articles' ,:action => 'show'
      #施工工具
      fe.connect '/shigonggongju', :controller => 'api_articles', :action => 'shigonggongju'
      #培训
      fe.connect '/peixun', :controller => 'api_articles', :action => 'peixun'
      fe.connect '/peixun/:id', :controller => 'api_articles', :action => 'peixun'
      fe.connect '/video/:title', :controller => 'paint_videos'
      # 针对油工的专题做的
      fe.connect '/yougong/:action.:format', :controller => 'api_oilers'

      # 油工调查问卷
      fe.resources :paint_questionnaires, :collection => [:get_city_json]
    end
    
    #油工个人信息后台
    www.with_options :front_or_backend => "backend" do |b|
      b.paint_worker_admin '/paint_worker/admin', :controller => 'paint_workers', :action => 'admin_index'
      b.connect '/paint_worker/:action', :controller => 'paint_workers'    
      
      #油工个人案例后台
      b.connect '/cases/admin', :controller => 'paint_cases', :action => 'admin_index'
      b.connect '/paint_cases/draft', :controller => 'paint_cases', :action => 'draft'
      b.resources :paint_cases, :collection => [:delete,:success], :except => :show
  #    www.connect '/cases/:id/edit', :controller => 'paint_cases', :action => 'admin_index'
      
      #油工登陆
      b.login '/admin/login', :controller => 'paint_sessions'
      #找回密码
      b.connect '/sessions/forgot_password', :controller => 'paint_sessions' , :action => 'forgot_password'
      b.logout '/sessions/logout', :controller => 'paint_sessions' , :action => 'logout'
    end
    
    www.with_options :front_or_backend => "front_end" do |fe|
      ## 2012年11月9日后添加的文章路径
      fe.connect '/articles', :controller => 'youqi_articles'
      fe.connect '/keywords/:id', :controller => 'paint_keywords', :action => "show"
      fe.connect '/:change/:date/:id', :controller => 'youqi_articles' ,:action => 'show'      
    end
  end
end
