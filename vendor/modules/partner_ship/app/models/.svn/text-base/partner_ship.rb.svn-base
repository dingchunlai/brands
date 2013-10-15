class PartnerShip < Hejia::Db::Product
  set_primary_key 'code'
  validates_presence_of :domain, :name, :code, :activity_begin_at, :activity_end_at
  validates_uniqueness_of :code

  default_scope :conditions => { :deleted => false }
  
  def mark_deleted
    update_attributes(:deleted => true)
  end
end