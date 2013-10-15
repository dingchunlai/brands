namespace :coupon do 
  desc "clear coupon_redis  for before_yestoday [pv , download, print] save 1 day ago data"
  task :clear_coupon_redis_data => :environment do

    #  每天早上运行 主要是删除前天的redis 数据 
    per_page = 500
    page = Coupon.all.count / per_page + 1
    (1..page).to_a.each do |i|

      Coupon.all.paginate(:page => i, :per_page => per_page).each do |coupon|
        pv = "coupons:#{coupon.id}:pv"

        time = 2.day.ago.strftime("%Y%m%d")
        if $redis.EXISTS(pv) == 1
          $redis.HDEL(pv, time) unless $redis.hget(pv, time).blank?
        end

        download = "coupons:#{coupon.id}:download"
        if $redis.EXISTS(download) == 1
          $redis.HDEL(download, time) unless $redis.hget(download, time).blank? 
        end

        print = "coupons:#{coupon.id}:print"
        if $redis.EXISTS(print) == 1
          $redis.HDEL(print, time) unless $redis.hget(print, time).blank?
        end

      end
    end
  end
end
