class CouponRemindMail < ActiveRecord::Base

  NOTICE_NUM= 10 # for mail notice
  ALERT_NUM = 5 # highlight

  validates_presence_of :recipient, :city_id
  validates_uniqueness_of :city_id


end