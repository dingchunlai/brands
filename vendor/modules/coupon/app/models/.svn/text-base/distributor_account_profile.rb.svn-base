class DistributorAccountProfile < ActiveRecord::Base

  belongs_to :distributor
  belongs_to :distributor_account
 
  validates_presence_of :distributor_id, :distributor_account_id

  named_scope :of_distributor, lambda { |distributor|
    distributor_id = distributor.is_a?(Distributor) ? distributor.id : distributor
    {
      :conditions => ["distributor_id = ?", distributor_id]
    }
  }
end
