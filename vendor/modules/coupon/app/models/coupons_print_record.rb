class CouponsPrintRecord < ActiveRecord::Base

  validates_presence_of :coupon_id, :print_record_id
  validates_uniqueness_of :coupon_id, :scope => :print_record_id
  belongs_to :coupon
  belongs_to :print_record

end
