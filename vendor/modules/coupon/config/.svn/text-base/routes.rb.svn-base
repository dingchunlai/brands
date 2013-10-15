ActionController::Routing::Routes.draw do |map|
 
  map.ajax_pop_login '/sessions/pop_login', :controller => 'sessions', :action => 'pop_login'

  map.with_options :conditions => {:subdomain => /^[A-Za-z0-9_-]*?\.?youhui$/} do |www|
    www.coupon_index '', :controller => :coupons, :action => :home
    www.for_static '/for_static', :controller => :coupons, :action => :home

    # 关于列表页
    www.coupon_search 'kw-:keyword-:order.html', :controller => :coupons, :action => :index_v2, :order => 0
    www.coupon_resultless 'resultless-:keyword.html', :controller => :coupons, :action => :no_results
    www.coupon_scope ':district_id-:bz_id-:shop_id-:tag_id-:brand_id-:pc_id-:order.html', :controller => :coupons, :action => :index_v2, :district_id => 0, :bz_id => 0, :shop_id => 0, :tag_id => 0, :brand_id => 0, :pc_id => 0, :order => 0

    www.coupon_show 'coupon/:id', :controller => :coupons, :action => :show_v2, :id => /[1-9]\d*/
    www.distributor_index 'distributor/:id/index', :controller => :distributors, :action => :index, :id => /[1-9]\d*/
    www.distributor_show 'distributor/:id', :controller => :distributors, :action => :show, :id => /[1-9]\d*/
    www.save_distributor_impression 'distributor/:id/save_impression', :controller => :distributors, :action => :save_impression, :id => /[1-9]\d*/
    www.coupon_top 'coupon/top', :controller => :coupons, :action => :top
    www.coupon_help 'coupon/help', :controller => :coupons, :action => :help
    www.coupon_print 'coupon/print', :controller => :coupons, :action => :print
    www.coupon_print_count 'coupon/print_count', :controller => :coupons, :action => :print_count
    www.coupon_confirm 'coupon/confirm', :controller => :coupon_downloads, :action => :confirm
    www.coupon_preview 'coupon/preview', :controller => :coupons, :action => :preview
    www.coupon_recommended 'coupon/recommended', :controller => :coupons, :action => :recommended
    www.save_recommended 'coupon/save_recommended', :controller => :coupons, :action => :save_recommended
    www.coupon_subscribes 'coupon/subscribe', :controller => :coupons, :action => :subscribe
    www.coupon_decofirm 'coupon/decofirm/:id', :controller => :coupons, :action => :decofirm
    www.promotion_industry '/coupon/promotion_industry', :controller => :coupons, :action => :promotion_industry
    www.resources :coupon_remarks, :path_prefix => 'coupon', :only => [:create]
    www.resources :offer_coupons, :path_prefix => 'coupon', :only => [:new, :create]
    www.resources :complaints, :path_prefix => 'coupon', :only => [:new, :create]
    www.resources :coupon_downloads, :path_prefix => 'coupon', :only => [:new, :create], :collection => { :send_sms => :post }

  end

  map.with_options :conditions => {:subdomain => false} do |b|

    b.namespace :distributor_user, :path_prefix => '/da', :name_prefix => 'distributor_user_' do |user|
      user.index 'dashboard', :controller => 'dashboards'
      user.login 'dashboard/login', :controller => 'user_sessions', :action => 'new'
      user.logout 'dashboard/logout', :controller => 'user_sessions', :action => 'destroy'
      user.resource :user_sessions, :only => [:new, :create, :destroy]
      user.resource :dashboards, :only => [:index, :changepwd, :create], :collection => { :changepwd => :get }
      user.resources :coupons, :except => [:destroy, :show]
      user.resources :shops, :except => [:destroy]
      user.resources :hy_images, :except => [:new , :edit, :destroy]
      user.resources :cases
      user.resources :activities
      user.resources :group_images, :except => [:new , :edit, :destroy], :member => { :set_default => :get }
      user.upload_img_form '/hyimages/form', :controller => 'hy_images', :action => 'render_form'
      user.group_upload_img_form '/gimages/form', :controller => 'group_images', :action => 'render_form'

    end

    b.namespace :admin do |admin|

      admin.resources :distributors, :member => {
        :industry_brand_setting => :get, :reset_password => :get, :save_industry_brand_setting => :post,
        :show_settings => :get, :save_settings => :put, :shops_json => :get, :decofirm => :get, :associate_decofirm => :post, :impressions => [:get, :post],
        :destroy_impression => :post
      } do |distributor|
        
        distributor.resources :contracts

        distributor.resources :shops, :collection => [:shops_by_title]
      end

      admin.resources :hy_images, :only => [ :index ], :member => { :aduit => :get }

      admin.resources :coupons, :collection => [:data, :sort, :insert_at, :move, :set, :on_line_display_amount], :member => {:putonline => :get, :print_image_preview => :get, :print_image_confirm => :post, :entrust => :get, :entrust_regen => :get, :sell_style => :get }

      admin.resources :coupon_leaflet_points, :as => :leaflets, :collection => [ :city_default ]

      admin.resources :coupon_remind_mails

      admin.resources :partner_ships, :as => :partners

      admin.resources :complaints, :member => {:confirm => :get}

      admin.resources :coupon_commissions

      admin.resources :offlines
      
      admin.resources :provinces

      admin.resources :cities

      admin.resources :districts

      admin.resources :business_zones

      admin.resources :markets

      admin.resources :market_shops

      admin.resources :coupon_faqs, :collection => [:group, :create_group, :update_group, :delete_group]

      admin.resources :print_records, :member => {:tag => :post, :tag_all => :get, :edit_tag => :post, :destroy_tag => :get, :pre => :get, :preview => :post, :print => :post, :cancel => :post}

      admin.resources :offer_coupons #, :except[:new]

      admin.resources :coupon_downloads, :collection => { :stat_download => :post, :stat => :get }, :only => [:index, :update]

      admin.resources :sales_profiles, :collection => { :assign_contracts => :get, :save_assign_contracts => :post }

      admin.resource :print_properties, :only => [:edit, :create]

      admin.index 'dashboard', :controller => 'coupon/index', :path_prefix => '/admin/coupon', :name_prefix => 'coupon_admin_'
      admin.login 'dashboard/login', :controller => 'user_sessions', :action => 'new', :path_prefix => '/admin/coupon', :name_prefix => 'coupon_admin_'
      admin.logout 'dashboard/logout', :controller => 'user_sessions', :action => 'destroy', :path_prefix => '/admin/coupon', :name_prefix => 'coupon_admin_'

      admin.resource :user_sessions, :only => [:new, :create, :destroy]
      
      admin.resources :location_relate_models, :collection  => [:relate_new,:create_all]

      admin.resources :coupon_issue_num_stats, :only => [:index, :new, :create]
      # admin.relate "/relate", :controller => ''

    end
  end
  map.connect '/second_killing', :controller => 'coupon_thematices', :action => 'second_killing'

end
