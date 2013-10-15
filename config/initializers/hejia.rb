Hejia.configuration.set :promotion_item_default_attributes => %w(title url publish_time entity_created_at).freeze,
                        :user_model => HejiaUserBbs,
                        :staff_model => RadminUser,
                        :redis => $redis,
                        :cache => MemCache.new('memcachehost:11211', {:namespace => "publish-#{RAILS_ENV}"})

JS_DOMAINS = (1..5).to_a.map! { |n| "js#{n}.51hejia.com" }
