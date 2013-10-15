namespace :coupon do
  desc "Update coupon commission."
  task :update_commission => :environment do
    # 佣金非 0 抵用券佣金置 0
    Coupon.update_all({ :commission => 0 }, "abs(commission) > 0")

    # 从抵用券佣金表中查询 本月抵用券佣金
    coupon_commissions = CouponCommission.find(:all, :conditions => ["activity_in = ? ", Time.zone.today.beginning_of_month])
    coupon_commissions.each do |coupon_commission|
      coupon = begin; Coupon.find(coupon_commission.coupon_id); rescue; end
      coupon.update_attributes(:commission => coupon_commission.commission) if coupon
    end
    puts "ok"
  end
end