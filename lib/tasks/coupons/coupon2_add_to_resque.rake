require 'resque/tasks'

namespace :coupon do
  desc "Coupon2 add to resque task"
  task :add2resque => :environment do
    Coupon.find(:all, :conditions => "show_image_url is null and list_thumbnail_url is null", :limit => 100, :select => 'id').each do |coupon|
      agreement = CouponEntrustAgreement.find_by_coupon_id(coupon.id) || CouponEntrustAgreement.create(:coupon_id => coupon.id, :status => 2)
      Resque::Job.create(:coupon_images_two, "Coupon::ImageGenerator::Job::SingleCouponV2", agreement.coupon_id)
    end
  end

  desc "Fix industry bg_image phone number error, regenerate coupons which belongs to these industries"
  task :fix2resque => :environment do
    Coupon.find(:all, :conditions => ["tag_id in (?)", [42093, 44583, 42889]], :select => 'id').each do |coupon|
      agreement = CouponEntrustAgreement.find_by_coupon_id(coupon.id) || CouponEntrustAgreement.create(:coupon_id => coupon.id, :status => 2)
      Resque::Job.create(:coupon_images_two, "Coupon::ImageGenerator::Job::SingleCouponV2", agreement.coupon_id)
    end
  end
end

