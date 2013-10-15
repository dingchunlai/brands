class FaqGroup < ActiveRecord::Base
  
  has_many :coupon_faqs

  named_scope :used_group, :order => "id ASC"

end
