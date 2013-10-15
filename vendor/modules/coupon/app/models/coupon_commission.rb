# -*- encoding: utf-8 -*-
class CouponCommission < ActiveRecord::Base
  belongs_to :coupon
  
  validates_presence_of :coupon_id, :commission, :activity_in
  validates_format_of :commission, :with => /^[1-9]\d*$/
  validates_format_of :activity_in, :with => /^20\d{2}-(0?[1-9]|1[0-2])-0?1$/
  validates_uniqueness_of :activity_in, :message => '此抵用券所在月份已设置过佣金!', :scope => :coupon_id

  default_scope :order => "activity_in desc", :conditions => ["deleted = ?", false]

  named_scope :limited, lambda { |num| { :limit => num } }

  named_scope :with_current_month, lambda { |coupon|
    {
        :conditions => ["coupon_id = ? and activity_in = ?", coupon, Time.zone.today.beginning_of_month ]
    }
  }

  def mark_deleted
    update_attributes(:deleted => true)
  end

end