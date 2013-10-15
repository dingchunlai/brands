namespace :coupon do 
  desc "update coupon downloads_count"
  task :update_error_coupon_dounloads_count => :environment do

    #  处理原有的下载数据
    per_page = 500
    page = Coupon.all.count / per_page + 1
    (1..page).to_a.each do |i|

      Coupon.all.paginate(:page => i, :per_page => per_page).each do |coupon|
        pv = "coupons:#{coupon.id}:pv"

        if $redis.EXISTS(pv) == 1
          (1..32).to_a.each do |today|
            time = today.day.ago.strftime("%Y%m%d")
            $redis.HDEL(pv, time) unless $redis.hget(pv, time).blank?
          end
        end

        download = "coupons:#{coupon.id}:download"
        if $redis.EXISTS(download) == 1
          (1..32).to_a.each do |today|
            time = today.day.ago.strftime("%Y%m%d")
            $redis.HDEL(download, time) unless $redis.hget(download, time).blank? 
          end
        end

        print = "coupons:#{coupon.id}:print"
        if $redis.EXISTS(print) == 1
          (1..32).to_a.each do |today|
            time = today.day.ago.strftime("%Y%m%d")
            $redis.HDEL(print, time) unless $redis.hget(print, time).blank?
          end
        end

        coupon.update_attribute :downloads_count, coupon.coupon_downloads.size
      end
    end

  end
end
