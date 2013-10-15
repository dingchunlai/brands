# Settings specified here will take precedence over those in config/envirjonment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# TODO when memcache get updated to 1.2.5, add :no_reply => true
config.cache_store = [:mem_cache_store, 'memcachehost:11211', {:namespace => 'hejia:brands:rehearsal', :autofix_keys => true}]

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.logger = begin
                  Hejia::SysLogger.app = 'brands'
                  Hejia::SysLogger.instance
                end
config.logger.level = 'info'

# Enable threaded mode
# config.threadsafe!
IS_PRODUCT = 1
