module Rack::Cache
  class MetaStore
    # 提供一个途径，设定不要缓存的headers，默认：Set-Cookie。
    # 这样可以避免缓存客户端限定的行为。
    class MemcacheFilter < MEMCACHE
      class << self; attr_accessor :private_headers end
      self.private_headers = ['Set-Cookie']

      private

      def persist_response(response)
        hash = response.headers.to_hash
        hash['X-Status'] = response.status.to_s
        self.class.private_headers.each { |filter| hash.delete filter }
        hash
      end
    end

    MEMCACHEFILTER = MemcacheFilter
  end
end
