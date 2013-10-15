namespace :coupon do
  desc "initialize coupon print properties"
  task :initialize_print_properties =>:environment do
    Coupon.all.each do |coupon|
      print_property = CouponPrintProperty.find_by_coupon_id(coupon.id) || CouponPrintProperty.create!(:coupon_id => coupon.id, :properties => '""');

      properties = coupon.print_properties
      properties.delete "area_color"
      properties.delete "tag_color"
      
      print_property.update_attribute(:properties, properties.to_json)
    end
    puts "ok"
  end
end