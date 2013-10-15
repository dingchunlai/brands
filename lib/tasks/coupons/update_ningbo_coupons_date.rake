require 'resque/tasks'

namespace :coupon do

  desc 'regenerate all coupon images for SingleCouponV2'
  task :regen_all_coupon_images => :environment do
    coupons = Coupon.find(:all)
    coupons.each do |coupon|
        print_property = CouponPrintProperty.find_by_coupon_id(coupon.id) || CouponPrintProperty.create!(:coupon_id => coupon.id, :properties => '""')

        properties = coupon.print_properties
        properties.delete "area_color"
        properties.delete "tag_color"

        print_property.update_attribute(:properties, properties.to_json)
        if RAILS_ENV == "production"
          Resque::Job.create(:coupon_images_two, "Coupon::ImageGenerator::Job::SingleCouponV2", coupon.id)
          puts "#{coupon.id} ok"
        else
          puts "#{coupon.id} ok"
        end
    end
  end

  desc 'update ningbo coupons end date'
  task :update_nb_coupons_date => :environment do
    #Coupon.update_all({:activity_end_at => '2011-12-31'}, ["city_id = ? and status=1 and activity_end_at <> ?", 214, "2011-12-31"])
    coupons = Coupon.find(:all, :conditions => ["city_id = ? and status=1 and activity_end_at <> ?", 214, "2011-12-31"])
    coupons.each do |coupon|
        print_property = CouponPrintProperty.find_by_coupon_id(coupon.id) || CouponPrintProperty.create!(:coupon_id => coupon.id, :properties => '""')

        coupon.update_attribute(:activity_end_at, "2011-12-31")
        
        properties = coupon.print_properties
        properties.delete "area_color"
        properties.delete "tag_color"

        print_property.update_attribute(:properties, properties.to_json)
        if RAILS_ENV == "production"
          Resque::Job.create(:coupon_images_two, "Coupon::ImageGenerator::Job::SingleCouponV2", coupon.id)
          puts "#{coupon.id} ok"
        else
          puts "#{coupon.id} ok"
        end
    end
  end

  desc 'regenerate shanghai coupons images'
  task :regenerate_shanghai_coupons_images => :environment do
    coupons = Coupon.find(:all, :conditions => ["city_id= ? and status=1", 1])
    coupons.each do |coupon|
      print_property = CouponPrintProperty.find_by_coupon_id(coupon.id) || CouponPrintProperty.create!(:coupon_id => coupon.id, :properties => '""')

      properties = coupon.print_properties
      properties.delete "area_color"
      properties.delete "tag_color"

      print_property.update_attribute(:properties, properties.to_json)
      if RAILS_ENV == "production"
        Resque::Job.create(:coupon_images_two, "Coupon::ImageGenerator::Job::SingleCouponV2", coupon.id)
        puts "#{coupon.id} ok"
      else
        puts "#{coupon.id} ok"
      end
    end
  end

end