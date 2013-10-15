class DistributorDecofirm < Hejia::Db::Product
  def self.table_name_prefix
    "product."
  end
  belongs_to :distributor
  belongs_to :deco_firm
end