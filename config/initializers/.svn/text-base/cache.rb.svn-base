module Brands
  # 最新一次发布的时间。
  # 因为发布是会重新从svn上拿一次完整的项目下来的，所以可以把这个文件的最后修改时间看作为最新的发布时间。
  # 那么就可以结合这个时间和网页内容的时间，来确定修改的时间了。
  # （可以考虑是否用Rails.root来代替__FILE__）
  LAST_MODIFIED = File.stat(Rails.root).mtime
end
=begin
# cache causes too many problem when the app is still in dev phrase
if Rails.env == 'production'
  gem 'memcache-client'
  require 'memcache'

  CACHE = MemCache.new ['memcachehost:11311'],
    :ttl         => 1,
    :compression => false,
    :debug       => false,
    :namespace   => "publish-#{Rails.env}",
    :readonly    => false,
    :urlencode   => false

  Hejia.configuration.cache = CACHE
  # ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.merge!({ 'cache' => CACHE })
end
=end
