class VipDistributorCase < ActiveRecord::Base
  has_many :pictures, :class_name => "Distributor::UploadPicture", :as => :resource
  validates_presence_of :title

  default_scope :conditions => { :deleted => false }

  def mark_deleted
    update_attributes(:deleted => true)
  end

end
