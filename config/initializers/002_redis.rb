require 'redis'

root = defined?(RAILS_ROOT) ? RAILS_ROOT : ENV['RAILS_ROOT'] || File.expand_path('../../..', __FILE__)
env  = defined?(RAILS_ENV)  ? RAILS_ENV  : ENV['RAILS_ENV']  || ENV['RACK_ENV']

$redis = Redis.new YAML.load_file(File.join(root, 'config/redis.yml'))[env.to_s]