class VipDistributorActivity < ActiveRecord::Base
  validates_presence_of :title, :begin_at, :end_at
  has_many :pictures, :class_name => "Distributor::UploadPicture", :as => :resource

  default_scope :conditions => { :deleted => false }

  def mark_deleted
    update_attributes(:deleted => true)
  end
end