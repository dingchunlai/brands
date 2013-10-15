namespace :coupon do
  desc "initialize coupon image generate for all coupons"
  # 必须先运行 init_coupon_print_properties task
  task :initialize_images_generate =>:environment do
    Coupon.all.each do |coupon|
      Resque::Job.create(:coupon_images, "Coupon::ImageGenerator::Job::SingleCoupon", coupon.id)
      coupon.update_attribute(:status, 4)
    end
    puts "ok"
  end
end