namespace :coupon do
  desc 'update coupon usage to default usage'
  task :update_default_usage => :environment do
    Coupon.all.each do |coupon|
      coupon.update_attribute(:usage, Coupon.default_usage)
    end
  end
end
