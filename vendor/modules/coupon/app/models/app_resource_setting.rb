# encoding : utf-8

class AppResourceSetting < Hejia::Db::Product
  # TODO 考虑实现通用的view partial
  default_scope :conditions => { :deleted => 0 }

  belongs_to :resource, :polymorphic => true
  validates_presence_of :name, :key, :value, :resource_type, :resource_id
  validates_uniqueness_of :key, :scope => [:resource_type, :resource_id, :channel]

#  def resource_type=(stype)
#     super(stype.to_s.classify.constantize.base_class.to_s)
#  end

#  before_save :update_resource_type_info
#
#  private
#  # TODO 通用的resource_type 不取用base_class.name的处理
#  def update_resource_type_info
#    # constantize deal with superclass? ancestors? ...
#    if self.resource_type == 'HejiaUserBbs'
#       self.resource_type = HejiaUserBbs.get_user(self.resource_id).class.name
#    end
#  end
end