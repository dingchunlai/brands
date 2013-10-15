# encoding: utf-8

require 'rack/utils'
require 'yajl/http_stream'

# 封装了一些google map api v3的使用方法。
# 就使用范围的局限性，这里就不做太多的灵活性和可扩展性的处理。等以后有需要再改进。
module GoogleMapAPI
  #@@host = 'http://maps.google.com'.freeze # 有时访问不了。。。。Great wall啊。。。。
  @@host = 'http://ditu.google.cn'.freeze

  module_function

  def geocode(address)
    geocode = nil

    Yajl::HttpStream.get(
      "#@@host/maps/api/geocode/json?sensor=false&language=zh&region=cn&address=#{Rack::Utils.escape address.gsub(/\s+/, '+')}"
    ) do |result|
      if result['status'] == 'OK'
        geocode = result['results'].first['geometry']['location'].values_at('lat', 'lng')
      else
        Rails.logger.error "[geocode] !FAILED! #{result['status']} | #{address}"
      end
    end

    geocode
  end

  def show_map(latitude, longitude, dom_id, options = nil)
<<_HTML_
<script type="text/javascript" src="#@@host/maps/api/js?v=3&sensor=false&language=zh&region=cn"></script>
<script type="text/javascript">
(function() {
  function show_map() {
    var latlng = new google.maps.LatLng(#{latitude}, #{longitude});
    var map = new google.maps.Map(document.getElementById('#{dom_id}'), {
      zoom: #{(options.try(:[], :zoom) || 16)},
      mapTypeId: google.maps.MapTypeId.#{options.try(:[], :type) || 'ROADMAP'},
      center: latlng
    });
    new google.maps.Marker({
      #{"title: %s," % options[:title].to_json if options.try(:[], :title)}
      position: latlng,
      map: map
    });
  }

  if(typeof jQuery == 'undefined') {
    show_map();
  } else {
    jQuery(show_map);
  }
})();
</script>
_HTML_
  end

  # 显示静态地图
  def show_static_map(latitude, longitude, options = nil)
    zoom = (options.try(:[], :zoom) || 16)
    format = (options.try(:[], :format) || 'png') 
    size = (options.try(:[], :size) || '350x280')
    markers = Rack::Utils.escape("color:blue|label:S|#{latitude},#{longitude}")
    center = Rack::Utils.escape("#{latitude},#{longitude}") 

    "#{@@host}/maps/api/staticmap?center=#{center}&zoom=#{zoom}&size=#{size}&format=#{format}&sensor=false&markers=#{markers}"
  end

end
