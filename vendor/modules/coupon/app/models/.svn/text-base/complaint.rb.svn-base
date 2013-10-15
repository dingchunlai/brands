class Complaint < ActiveRecord::Base
  belongs_to :coupon

  validates_presence_of :name, :telphone, :body, :title
  validates_presence_of :coupon_id, :coupon_code, :on => :create
  validates_format_of :coupon_id, :with => /[1-9]\d*/, :on => :create
  
  validates_format_of :email, :with => /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/, :unless => Proc.new { |c| c.email.blank? }
  validates_format_of :telphone, :with => /(^(\d{2,4}[-_－—]?)?\d{3,8}([-_－—]?\d{3,8})?([-_－—]?\d{1,7})?$)|(^0?1[35]\d{9}$)/

  validates_length_of :name, :maximum => 30
  validates_length_of :title, :maximum => 100
  validates_length_of :telphone, :maximum => 20
  validates_length_of :email, :maximum => 100
  validates_length_of :address, :maximum => 150

  default_scope :conditions => ["deleted = ?", false], :order => "id DESC"

  named_scope :search, lambda { |query|
    cnt = query[:cnt].to_i
    unit = query[:unit].to_i
    coupon = query[:coupon_id].to_i
    if coupon > 0
      if (cnt > 0 and unit > 0)
        offsets = cnt * unit * 24 * 3600
        # or Date.today offset day => not accurate
        {
            :conditions => ["created_at >= ? and coupon_id = ?", Time.now - offsets, coupon ]
        }
      else
        {
            :conditions => ["coupon_id = ?", coupon ]
        }
      end
    else
      if (cnt > 0 and unit > 0)
        offsets = cnt * unit * 24 * 3600
        # or Date.today offset day => not accurate
        {
           :conditions => ["created_at >= ?", Time.now - offsets ]
        }
      end
    end
  }

  def mark_deleted
    update_attributes(:deleted => true)
    if self.is_valid?
      distributor_id = self.coupon.distributor_id
      Distributor.decrement_counter(:complaints_count, distributor_id)
    end
  end

  class << self 
    def valid_count
      count_by_sql("select count(*) from complaints where deleted = 0")
    end
  end

end
