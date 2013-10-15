# encoding : utf-8

class DistributorAccountIndustryBrand < Hejia::Db::Product
  belongs_to :distributor_account
  belongs_to :industry
  belongs_to :brand
end