module Jobs
  module Coupon
    class AfterImageCreated
      @queue = :coupons

      def self.perform(*args)
        #p "=============" p to log ?
        if args.size > 0
          coupon_id = args[0].to_i
          coupon = ::Coupon.find(coupon_id)
          coupon.update_attribute(:status, 1)
        end
      end

    end
  end
end