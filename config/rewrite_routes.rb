# encoding: utf-8
# examples:
# rewrite '/wiki/John_Trupiano', '/john'
# z.r301 '/wiki/Yair_Flicker', '/yair'
# r302 '/wiki/Greg_Jastrab', '/greg'
# z.r301 %r'/wiki/(\w+)_\w+', '/$1'

#公司列表页^/abc$|^/abc/$
#-----------frims star---------------(\d*)

conditions = {
  :if => Proc.new { |env| env['HTTP_HOST'] =~ /^z\./ }
}
with_options conditions do |z|
  #z.r301 %r'^(/zhuangxiugongsi|/zhuangxiugongsi/)$', '/companies/'  #列表首页
  #z.r301 %r'/zhuangxiugongsi-(\d*)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-0', '/companies-$2$3$5$1-$4/' #上个版本公司列表页带参数的第一页的路由
  z.r301 %r'^/zhuangxiugongsi-(\d*)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d*)', '/companies-$2$3$5$1-$4-$8/' #上个版本公司列表页带参数的带页码的路由
  #z.r301 %r'^/zhuangxiugongsi-(.*)', '/companies/' #其它老的路由
  #z.r301 %r'^/zhuangxiugongsi\?(.*)', '/companies?$1' #统计路由
  # condition = '1 => model ,2 => style,3 => price,4 => district'  #备忘

  #工装
  #z.r301 %r'^/gongzhuang/page/(\d*)','/company_decoration-$1/'
  #z.r301 %r'^/gongzhuang\?(.*)', '/company_decoration?$1' #统计路由

  #别墅
  #z.r301 %r'^/bieshu/page/(\d*)', '/villa-$1/'
  #z.r301 %r'^/bieshu(.*)', lambda { |match, env| match[1].blank? ? '/villa/' : "/villa#{match[1]}" }

  #日记列表页
  z.r301 %r'^/zhuangxiugushi-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)', '/stories-$1$2$3$4-$6-$7/' 
  #z.r301 %r'^/zhuangxiugushi(.*)?', lambda { |match, env| match[1].blank? or match[1][0] == ?- ? '/stories/' : "/stories#{match[1]}" }
  #condition = '1 => model ,2 => style,3 => price,4 => room'

  #装修案例
  #z.r301 %r'^(/zhuangxiuanli|/zhuangxiuanli/)$', '/cases/'
  #z.r301 %r'/zhuangxiuanli/page/(\d*)','/cases-$1/'
  z.r301 %r'/zhuangxiuanli-(\d+)-(\d+)-(\d+)-(\d+)-(\d+)-(\d*)', '/cases-$3$2$1$5-$6/'
  #z.r301 %r'/zhuangxiuanli(\?.*)?', '/cases$1' #统计路由
  #condition = '1 => model ,2 => style,3 => price,4 => room'

  #施工图片列表页
  #z.r301 %r'^/shigongtupian\?(.*)', '/shigongtupian?$1'#统计路由
  #z.r301 %r'^/shigongtupian','/gallaries/'
  #z.r301 %r'^/shigongtupian/page/(\d*)','/gallaries-$1/'

  #排行榜
  #z.r301 %r'^/top\?(.*)', '/rank?$1'#统计路由
  #z.r301 %r'^(/top|/top/)$' , '/rank/'

  #优惠券
  #z.r301 %r'^(/coupon|/coupon/)$' , '/coupons/'
  #z.r301 %r'^/coupon-(\d*)' , '/coupons-$1/'
  #z.r301 %r'^/coupon\?(.*)', '/coupons?$1'#统计路由

  mapping = {
    'zhuangxiugongsi' => 'companies',
    'zhuangxiugushi'  => 'stories',
    'gongzhuang'      => 'company_decoration',
    'bieshu'          => 'villa',
    'zhuangxiuanli'   => 'cases',
    'shigongtupian'   => 'gallaries',
    'top'             => 'rank',
    'y'               => 'coupons'
  }
  r301 %r"^/(#{mapping.keys.join '|'})/page/(\d*)", lambda { |match, env| "/#{mapping[match[1]]}-#{match[2]}/" }, conditions
  r301 %r"^/(#{mapping.keys.join '|'})(.*)", lambda { |match, env| match[2].blank? ? "/#{mapping[match[1]]}/" : "/#{mapping[match[1]]}#{match[2]}" }, conditions

=begin
  #日记终端页
  z.r301 %r'/gs-(\d*)/zhuangxiugushi/(\d*)(\?.*)?', '/stories/$2$3'
  #案例终端页
  z.r301 %r'/gs-(\d*)/cases-(\d*)(\?.*)?', '/cases/$2$3'
  #优惠券终端页
  z.r301 %r'/gs-(\d*)/y-(\d*)(\?.*)?', '/coupons/$2$3'

  #设计理念
  z.r301 %r'/gs-(\d*)/shejilinian/(\d*)(\?.*)?', '/ideas/$2$3'#统计路由
  #设计师
  z.r301 %r'/gs-(\d*)/designers/(\d*)(\?.*)?', '/designers/$2$3'#统计路由
  #某公司下的列表页
  z.r301 %r'/gs-(\d*)/zhuangxiugushi(\?.*)?', '/$1/stories$2'#日记统计路由

  z.r301 %r'/gs-(\d*)/zhuangxiuanli(\?.*)?', '/$1/cases$2'#案例统计路由

  z.r301 %r'/gs-(\d*)/shigongtupian(\?.*)?', '/$1/gallaries$2'#施工图片统计路由

  z.r301 %r'/gs-(\d*)/zaijiangongdi(\?.*)?', '/$1/ongoing$2'#在建工地统计路由

  z.r301 %r'/gs-(\d*)/designers(\?.*)?', '/$1/designers$2'#设计师统计路由

  z.r301 %r'/gs-(\d*)/shejilinian(\?.*)?', '/$1/ideas$2'#设计理念统计路由

  # z.r301 %r'/gs-(\d*)/y-(^\d*$)', '/$1/coupons/' #优惠券
  #公司终端页
  z.r301 %r'/gs-([1-9]\d*)\?(.*)?', '/$1?$2'
  z.r301 %r'/gs-([1-9]\d*)', '/$1/'#设计理念统计路由
=end

  company_mapping = mapping.merge(
    'shejilinian' => 'ideas',
    'zaijiangongdi' => 'ongoing'
  )
  r301 %r"^/gs-(\d+)(/[^\?/-]*)?(.*)", lambda { |match, env|
    (resource = match[2] || '').sub! %r'^/', ''
    path_info = match[3]

    if resource.blank? # 公司终端页
      "/#{match[1]}/#{path_info}"
    else
      resource = company_mapping.has_key?(resource) ? company_mapping[resource] : resource
      path_info.sub! %r'^/', ''
      path_info.sub! /^-/, ''

      if path_info =~ /^\d+/
        "/#{resource}/#{path_info}"
      else
        "/#{match[1]}/#{resource}#{path_info}"
      end
    end
  }, conditions
end

__END__

#============================= old 1 =================================  old 1 ==============================  old 21====================================================


#公司列表页
# 
# #下面是几个是公司列表页老的路由 ，有些根本不知道是什么东西,现统一301跳转新路由
# #    ********star ************
# z.connect '/zhuangxiugongsi/:cityname-gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect '/zhuangxiugongsi/gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/:page', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect '/zhuangxiugongsi/gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'zhuangxiugongsi/:district.:model.:style.:order.:price.:page.html', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'zhuangxiugongsi-:city-:district-:model-:style-:order-:price-:page/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'zhuangxiugongsi-:city-:district-:model-:style-:order-:price-:hcase-:hcommont-:page/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'dianping-:city-:district-:model-:style-:order-:price-:page/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# #    ********* end ****************
# 
# #新的
# z.connect '/zhuangxiugongsi-:district-:model-:style-:order-:price-:hcase-:hcommont-:page', :controller => 'dianping/firms', :action => "index"
# z.connect '/zhuangxiugongsi-0-0-0-:order-0-0-0-:page', :controller => 'dianping/firms', :action => "index" #翻页路由
# z.connect '/zhuangxiugongsi-0-0-0-0-0-0-0-:page', :controller => 'dianping/firms', :action => "index" #翻页路由
# 
# z.firms '/zhuangxiugongsi', :controller => 'dianping/firms', :action => "index"
# 
# #工装列表
# map.connect '/gongzhuang/page/:page', :controller => "dianping/firms", :action => 'gongzhuang'
# map.connect '/gongzhuang', :controller => "dianping/firms", :action => 'gongzhuang'
# 
# #别墅列表
# map.connect '/bieshu', :controller => "dianping/firms", :action => 'bieshu'
# map.connect '/gongzhuang/page/:page', :controller => "dianping/firms", :action => 'bieshu'

# #新的日记列表页
# z.connect '/zhuangxiugushi-:model-:style-:price-:room-:keyword-:order-:page', :controller => 'dianping/decoration_diaries', :action => "index"
# z.connect '/zhuangxiugushi-0-0-0-0-0-:order-:page', :controller => 'dianping/decoration_diaries', :action => "index" #翻页路由
# z.connect '/zhuangxiugushi-0-0-0-0-0-0-:page', :controller => 'dianping/decoration_diaries', :action => "index" #翻页路由
# 
# #日记列表页
# 
# z.connect '/zhuangxiugushi/:method-:style-:price-:stage-:room-:alltype-:title-:myorder-:dianping', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/:method-:style-:price-:stage-:room-:alltype-:title-:myorder-:dianping-:page', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/:page' , :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# 
# z.connect '/zhuangxiugushi/orderby/:order/page/:page', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/orderby/:order', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/page/:page', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi', :controller => 'dianping/decoration_diaries', :action => "index"

    # z.decoration_diaries 'zhuangxiugushi', :controller => "dianping/decoration_diaries", :action => "index"
    #案例  
    # z.connect '/zhuangxiuanli-:price-:style-:model-:use-:room-:page', :controller => 'dianping/cases', :action => "index"
    # z.cases_page 'zhuangxiuanli/page/:page', :controller => 'dianping/cases', :action => "index"
    # z.cases 'zhuangxiuanli', :controller => 'dianping/cases', :action => "index"


    # #施工图片
    # z.construction_photos_page 'shigongtupian/page/:page' , :controller => 'dianping/construction_photos', :action => "index"
    # z.construction_photos 'shigongtupian' , :controller => 'dianping/construction_photos', :action => "index"
    # z.top 'top', :controller => "dianping/top", :action =>"index"
    # z.coupons '/coupon' ,:controller => "dianping/coupons" ,:action => "index"
    # z.connect '/gs-:firm_id/y-:coupon_id' ,:controller => "dianping/coupons" ,:action => "show"
#============================= old 2 =================================  old 2 ==============================  old 2 ====================================================


# z.stat 'stat/:action/:id.gif', :controller => "stat"
# z.connect 'user_sessions/:action', :controller =>"user_sessions"
# z.root :controller => 'dianping/home'
# # z.connect 'remarks/pop_form', :controller =>"dianping/remarks",:action =>""
# z.resources :remarks, :controller => "dianping/remarks", :collection => [:pop_form]
# z.firm_decoration_diaries 'gs-:firm_id/zhuangxiugushi', :controller => 'dianping/firm/decoration_diaries', :action => "index"
# z.decoration_diary 'gs-:firm_id/zhuangxiugushi/:id', :controller => "dianping/decoration_diaries", :action => "show"
# #以前日记终端页路由转向到新的路由
# z.connect '/gs-:fid/zhuangxiugushi/:nid/all/:page', :controller => "dianping/decoration_diaries", :action => 'turn_to'
# z.connect '/gs-:fid/zhuangxiugushi/:nid/all/:page/:pagesize', :controller => "dianping/decoration_diaries", :action => 'turn_to'
# z.connect '/gs-:fid/zhuangxiugushi/:nid/tag-:type/:page', :controller => "dianping/decoration_diaries", :action => 'turn_to'
# 
# z.top 'top', :controller => "dianping/top", :action =>"index"
# #公司优惠券
# #    z.resources :coupons, :controller => "dianping/coupons" ,:as => :coupon,:only => [:index ,:show]
# z.coupons '/coupon' ,:controller => "dianping/coupons" ,:action => "index"
# z.connect '/gs-:firm_id/y-:coupon_id' ,:controller => "dianping/coupons" ,:action => "show"
# # 设计理念
# z.firm_deco_ideas 'gs-:firm_id/shejilinian', :controller => 'dianping/firm/deco_ideas', :action => "index"
# z.deco_idea 'gs-:firm_id/shejilinian/:id', :controller => "dianping/deco_ideas", :action => "show"
# #    z.firms 'zhuangxiugongsi', :controller => 'dianping/firms', :action => "index"
# z.connect '/zhuangxiuanli-:price-:style-:model-:use-:room-:page', :controller => 'dianping/cases', :action => "index"
# z.cases_page 'zhuangxiuanli/page/:page', :controller => 'dianping/cases', :action => "index"
# z.cases 'zhuangxiuanli', :controller => 'dianping/cases', :action => "index"
# z.case 'gs-:firm_id/cases-:id', :controller => 'dianping/cases', :action => "show"
# z.case_up 'cases-:id/up', :controller => 'dianping/cases', :action => "up", :method => "post"
# z.case_down 'cases-:id/down', :controller => 'dianping/cases', :action => "down", :method => "post"
# z.downcase 'anli/down_case/:id', :controller => 'dianping/cases', :action => "downcase", :method => "get"
# 
# z.firm_cases 'gs-:firm_id/zhuangxiuanli', :controller => 'dianping/firm/cases', :action => "index"
#  
# z.firm_factories 'gs-:firm_id/zaijiangongdi', :controller => 'dianping/firm/factories', :action => "index"
# z.firm_construction_photos 'gs-:firm_id/shigongtupian', :controller => 'dianping/firm/construction_photos', :action => "index"
# z.firm_designers 'gs-:firm_id/designers', :controller => 'dianping/firm/designers', :action => "index"
# z.designer 'gs-:firm_id/designers/:id', :controller => 'dianping/designers', :action => "show"
#   
# z.save_deco_impression 'firms/save_deco_impression' ,:controller => 'dianping/firms', :action => "save_deco_impression", :path_prefix => "dianping"
# z.deco_impression 'firms/deco_impression' ,:controller => 'dianping/firms', :action => "deco_impression"#, :path_prefix => "dianping"
# z.top_deco_impression 'firms/top_deco_impression' ,:controller => 'dianping/firms', :action => "top_deco_impression"#, :path_prefix => "dianping"
#   
# z.namespace :dianping do |d|
#   # 在线预约装修公司
#   d.resources :applicants, :only => [:create,:new], :path_prefix => "dianping"
#   # 在线申请在建工地
#   d.resources :deco_registers, :only => [:create, :new], :collection => "new_iframe", :path_prefix => "dianping"
# end
#   
# # 单个公司内部页面
# z.firm 'gs-:id', :controller => 'dianping/firms', :action => "show"
# 
# #公司列表页
# 
# #下面是几个是公司列表页老的路由 ，有些根本不知道是什么东西,现统一301跳转新路由
# #    ********star ************
# z.connect '/zhuangxiugongsi/:cityname-gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect '/zhuangxiugongsi/gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/:page', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect '/zhuangxiugongsi/gsl-:city-:district/:model-:style-:order-:price-:hcase-:hcommont/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'zhuangxiugongsi/:district.:model.:style.:order.:price.:page.html', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'zhuangxiugongsi-:city-:district-:model-:style-:order-:price-:page/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'zhuangxiugongsi-:city-:district-:model-:style-:order-:price-:hcase-:hcommont-:page/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# z.connect 'dianping-:city-:district-:model-:style-:order-:price-:page/', :controller => 'dianping/firms', :action => "firm_url_turn_to"
# #    ********* end ****************
# 
# #新的
# z.connect '/zhuangxiugongsi-:district-:model-:style-:order-:price-:hcase-:hcommont-:page', :controller => 'dianping/firms', :action => "index"
# z.connect '/zhuangxiugongsi-0-0-0-:order-0-0-0-:page', :controller => 'dianping/firms', :action => "index" #翻页路由
# z.connect '/zhuangxiugongsi-0-0-0-0-0-0-0-:page', :controller => 'dianping/firms', :action => "index" #翻页路由
# 
# z.firms '/zhuangxiugongsi', :controller => 'dianping/firms', :action => "index"
# 
# #工装列表
# map.connect '/gongzhuang/page/:page', :controller => "dianping/firms", :action => 'gongzhuang'
# map.connect '/gongzhuang', :controller => "dianping/firms", :action => 'gongzhuang'
# 
# #别墅列表
# map.connect '/bieshu', :controller => "dianping/firms", :action => 'bieshu'
# map.connect '/gongzhuang/page/:page', :controller => "dianping/firms", :action => 'bieshu'
# 
# #新的日记列表页
# z.connect '/zhuangxiugushi-:model-:style-:price-:room-:keyword-:order-:page', :controller => 'dianping/decoration_diaries', :action => "index"
# z.connect '/zhuangxiugushi-0-0-0-0-0-:order-:page', :controller => 'dianping/decoration_diaries', :action => "index" #翻页路由
# z.connect '/zhuangxiugushi-0-0-0-0-0-0-:page', :controller => 'dianping/decoration_diaries', :action => "index" #翻页路由
# 
# #日记列表页
# 
# z.connect '/zhuangxiugushi/:method-:style-:price-:stage-:room-:alltype-:title-:myorder-:dianping', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/:method-:style-:price-:stage-:room-:alltype-:title-:myorder-:dianping-:page', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/:page' , :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# 
# z.connect '/zhuangxiugushi/orderby/:order/page/:page', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/orderby/:order', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi/page/:page', :controller => 'dianping/decoration_diaries', :action => "firm_list_url_turn_to"
# z.connect '/zhuangxiugushi', :controller => 'dianping/decoration_diaries', :action => "index"
# z.decoration_diaries 'zhuangxiugushi', :controller => "dianping/decoration_diaries", :action => "index"
# #施工图片
# z.construction_photos_page 'shigongtupian/page/:page' , :controller => 'dianping/construction_photos', :action => "index"
# z.construction_photos 'shigongtupian' , :controller => 'dianping/construction_photos', :action => "index"
# #专题/专访
# z.theme_page '/theme/page/:page', :controller => 'dianping/theme', :action => "index"
# z.theme '/theme', :controller => 'dianping/theme', :action => "index"
# ======  end  =============================  end  ===================  end  ===================  end  ===================  end  ===================  end  ==============
