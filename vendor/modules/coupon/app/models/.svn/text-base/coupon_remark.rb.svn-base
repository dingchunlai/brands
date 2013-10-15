class CouponRemark < Hejia::Db::Hejia
  set_table_name "remarks"
  belongs_to :user, :class_name => "HejiaUserBbs"
  belongs_to :resource, :polymorphic => true, :counter_cache => :remarks_count
  has_many :replies, :class_name => 'CouponRemark', :foreign_key => :parent_id
  validates_presence_of :content
  validates_presence_of :user_id, :message => "请先行登录"
  
end
