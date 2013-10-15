class CouponPrintProperty < ActiveRecord::Base
  validates_presence_of :coupon_id, :properties
  validates_uniqueness_of :coupon_id

  default_scope :conditions => { :deleted => false }
end