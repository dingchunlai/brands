# 临时使用
class CouponEntrustAgreement < ActiveRecord::Base
  # status 0 无图 1正常 2图生成中
  validates_presence_of :coupon_id
  
end