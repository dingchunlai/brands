module Jobs
  module Coupon
    class AfterImageCreatedV2
      @queue = :coupons_two

      def self.perform(*args)
        if args.size > 0
          coupon_id = args[0].to_i
          agreement = ::CouponEntrustAgreement.find_by_coupon_id(coupon_id)
          agreement.update_attribute(:status, 1)
        end
      end
    end
  end
end