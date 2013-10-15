# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

initializer = Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.autoload_paths += %W( #{RAILS_ROOT}/app/filters )
  config.plugin_paths << "#{RAILS_ROOT}/vendor/modules"

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'SystemTimer', :lib => false
  config.gem 'mysql2'
  config.gem 'will_paginate', :version => '~> 2'
  config.gem 'cancan', :version=>'1.3.4'
  config.gem 'subdomain-fu', :version => '>= 0.5.4'
  config.gem 'nokogiri', :lib => false
  config.gem 'hejia_ext_links', :version => '>= 0.7.12', :lib => 'hejia'
  config.gem 'redis'
  config.gem 'redis-namespace'
  config.gem 'paperclip'
  config.gem 'ambethia-smtp-tls' ,:version =>'1.1.2' , :lib => 'smtp-tls' ,:source => "http://gems.github.com"
  config.gem 'searchlogic',:version => '2.4.24'
  config.gem "cells", :version => '3.3.5'
  config.gem 'yajl-ruby', :lib => 'yajl'
  config.gem 'ya2yaml'
  config.gem 'dalli'
  config.gem 'hoptoad_notifier'
  config.gem 'rack-cache',   :lib => 'rack/cache'
  config.gem 'rack-rewrite', :lib => 'rack/rewrite'
  config.gem 'fastercsv', :version => '1.5.3'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  config.frameworks -= [ :active_resource ]

  config.middleware.insert_before 'Rack::Lock', 'Rack::Rewrite' do
    instance_eval File.read(File.join(Rails.root, 'config/rewrite_routes.rb'))
  end if File.file?(File.join(Rails.root, 'config/rewrite_routes.rb'))

  config.middleware.insert_before 'ActionController::Failsafe', 'Hejia::IpBlacklist'

  #config.middleware.insert_before 'ActionController::Failsafe', 'Rack::Cache' do |cache|
  config.middleware.insert_before 'ActionController::ParamsParser', 'Rack::Cache' do |cache|
    require 'lib/rack/cache/metastore/memcache_filter'
    #cache.set :cache_key TODO params filter
    ns_suffix = Rails.env.production? && ':production' || nil
    cache.set :metastore,        "memcachefilter://memcachehost/rack-cache:meta#{ns_suffix}"
    cache.set :entitystore,      "memcache://memcachehost/rack-cache:entity#{ns_suffix}"
    cache.set :allow_reload,     false
    cache.set :allow_revalidate, false
  end if Rails.env.production? or Rails.env.rehearsal?

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Beijing'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  config.i18n.default_locale = :zh
end

# vendor/modules下开发的代码能够自动读取变更
# 不要用config.reload_plugins = true
# 因为会导致一些插件引起问题！
if RAILS_ENV == 'development'
  modules_dir = %r'vendor/modules/'
  initializer.plugin_loader.engines.each { |engine|
    engine.load_paths.each { |path| ActiveSupport::Dependencies.autoload_once_paths.delete path } if modules_dir === engine.directory
  }
end

require 'brands/core_ext/hash/deep_values'

WillPaginate::ViewHelpers.pagination_options[:renderer] = 'MyLinkRenderer'

ActionController::Base.session_options[:memcache_server] = 'memcachehost:11211' if Rails.env.development? or Rails.env.staging?
