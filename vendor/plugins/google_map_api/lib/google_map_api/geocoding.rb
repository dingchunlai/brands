module GoogleMapAPI
  module Geocoding

    # 就使用范围的局限性，这里就不做太多的灵活性和可扩展性的处理。等以后有需要再改进。
    @@url = "http://maps.google.com/maps/api/geocode/json?sensor=false&language=zh&region=cn&address=".freeze

    Yajl::HttpStream.get("http://maps.google.com/maps/api/geocode/json?sensor=false&language=zh&region=cn&address=#{URI.encode address.gsub(/\s+/, '+')}") do |chunk|
      module_function

      def geocode(address, options)
      end
    end
  end
end
