ActionController::Routing::Routes.draw do |map|

  map.with_options :conditions => {:subdomain => /\Az\.\w+/} do |z| 
    z.glory_feature '/features/glory/:date.:foramt', :controller => 'features', :action => 'glory', :requirements => {:date => /\d{6}/}
    z.connect '/features/free/2011.:format',         :controller => 'features', :action => 'free'
    z.features '/features/:action.:foramt',          :controller => 'features'
  end

  map.with_options :conditions => {:subdomain => /^(www)$/} do |zt| 
    zt.news_feature '/xinwen/news/:date/index.html', :controller => 'features', :action => 'news', :requirements => {:date => /\d{6}/}
  end

end
