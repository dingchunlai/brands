class CouponRecommendation < ActiveRecord::Base

  validates_presence_of :coupon_id, :name
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => 'email must be valid'

  belongs_to :coupon

end
