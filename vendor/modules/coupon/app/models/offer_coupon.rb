class OfferCoupon < ActiveRecord::Base
   validates_presence_of :merchant, :body, :linkman, :telphone, :city_id, :district_id

   validates_length_of :merchant, :maximum => 50
   validates_length_of :linkman, :maximum => 30
   validates_length_of :telphone, :maximum => 30
   validates_format_of :telphone, :with => /(^(\d{2,4}[-_－—]?)?\d{3,8}([-_－—]?\d{3,8})?([-_－—]?\d{1,7})?$)|(^0?1[35]\d{9}$)/
   validates_format_of :city_id, :district_id, :with => /^[1-9]\d*$/

   belongs_to :city
   belongs_to :district

   default_scope :conditions => { :deleted => false }

   named_scope :with_merchant, lambda { |merchant|
     {
        :conditions => merchant.to_s.blank? ? nil : ["merchant like ?", "%#{merchant}%"]
     }
   }

   named_scope :with_status, lambda { |status|
     case status
       when "1"
         conditions = ["status = ?", 1]
       when "0"
         conditions = ["status = ?", 0]
       else
         conditions = nil
     end
     {
             :conditions => conditions
     }
   }
end