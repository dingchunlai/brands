class CouponDownload < ActiveRecord::Base
  belongs_to :coupon

  validates_presence_of :coupon_id
  validates_format_of :mobile, :with => /^1[3|5|8]\d{9}$/, :message => '号码错误'

  after_save :send_msg_for_mobile

  named_scope :with_coupon, lambda {|coupon_id|
    coupon_id = coupon_id.kind_of?(Coupon) ? coupon_id.id : coupon_id
    {
      :conditions => ["coupon_id = ?", coupon_id],
      :order => "id DESC"
    }
  }

  named_scope :with_coupon_brand, lambda {|brand_id|
    {
      :select => 'coupons.id',
      :joins => 'JOIN coupons ON coupon_downloads.coupon_id = coupons.id',
      :conditions => ['coupons.brand_id = ?', brand_id]
   }
  }


  # 取得当天下载数
  def self.today_down_number
    count(:conditions => ["created_at like ?", "%#{Time.now.strftime('%Y-%m-%d')}%"])
  end

  # 取得昨天下载数
  def self.yesterday_down_number
    count(:conditions => ["created_at like ?", "%#{1.day.ago.strftime('%Y-%m-%d')}%"])
  end

  # 确认手机号码
  def verify_mobile
    update_attribute :is_confirm, true
  end

  # 保存完之后的操作
  def send_msg_for_mobile
    # 向用户手机发送短信
    Hejia::SMS.send_text_message(coupon.sms_msg, mobile)
 end
 private :send_msg_for_mobile
end
