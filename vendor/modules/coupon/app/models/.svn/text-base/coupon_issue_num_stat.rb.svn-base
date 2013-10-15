# encoding: utf-8

class CouponIssueNumStat < ActiveRecord::Base
  validates_presence_of :coupon_id
  validates_format_of :counts, :with => /^[1-9]+([0-9]*)$/

end