namespace :coupon do 
  desc "every day update coupon_table status value"
  task :update_coupon_status => :environment do

    # 1. 每天早上执行 结束日期为 昨天的抵用卷
    #    将抵用券状态值[status] 更改为 5 已过期
    #    分页进行处理
    per_page = 500
    page = Coupon.period_as_today_and_valid.count / per_page + 1
    (1..page).to_a.each do |i|
      Coupon.period_as_today_and_valid.paginate(:page => i, :per_page => per_page).each do |coupon|
        coupon.update_attribute :status, 5
        distributor = coupon.distributor
        # 在经销商中将此抵用卷数量减去  1
        distributor.update_attribute(:coupons_count, (distributor.coupons_count - 1))
      end
    end

  end

  desc 'update coupon sms message'
  task :update_coupon_sms_msg => :environment do
    coupons = Coupon.all
    coupons.each do |record|
      
      shop = record.distributor_shop
      address = ''
      if shop.market_shop_id.nil?
        address = shop.address
      else
        market_shop = MarketShop.find(shop.market_shop_id)
        market = market_shop.market
        address = "#{market.name}(#{shop.address})"
      end

      record.sms_msg = "#{record.brand.name_zh}#{record.tag.TAGNAME}现金券"\
                  "#{record.return_amount}元(满#{record.discount_amount}元使用),地址:"\
                  "#{address},#{record.activity_began_at('%m.%d')}-#{record.activity_end_at('%m.%d')}有效,客服400-602-5151【和家网】"
      record.save
      puts "#{record.id} ok"
    end
  end
  
end
