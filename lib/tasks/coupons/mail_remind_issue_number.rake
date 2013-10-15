namespace :coupon do

  desc "send mail for coupon remain issue number notice"
  task :remind_mail => :environment do
    
#    sql = "SELECT coupons.id, coupons.city_id, coupons.existing_number, coupons.code, coupons.title, `51hejia.radmin_users.name` as sales_name FROM `coupons`" \
#          " inner join distributor_contracts on coupons.contract_id = distributor_contracts.id" \
#          " inner join `51hejia.radmin_user` on distributor_contracts.radmin_user_id = `51hejia.radmin_users`.id" \
#          " WHERE (coupons.activity_end_at >= '#{Time.zone.today}' and coupons.deleted=0 and coupons.existing_number <= #{CouponRemindMail::NOTICE_NUM})" \
#          " ORDER BY coupons.existing_number asc"
    coupons = Coupon.find(
        :all,
        :select => "id, city_id, existing_number, code, title, contract_id",
        :order => 'existing_number asc',
        :conditions => ["activity_end_at >= ? and existing_number <= ?", Time.zone.today, CouponRemindMail::NOTICE_NUM]
    )

    unless coupons.empty?
      coupon_hash = coupons.group_by(&:city_id)
      coupon_hash.each do |key, value|
        remain_mail = CouponRemindMail.first(:conditions => ["city_id = ?", key])
        Notifier.deliver_notice_remain_issue(remain_mail, value)
        puts "#{Coupon::CITIES[remain_mail.city_id]} sent ok."
      end
    end
    
  end
end