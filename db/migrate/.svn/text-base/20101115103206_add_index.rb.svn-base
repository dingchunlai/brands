class AddIndex < ActiveRecord::Migration
  def self.up
    # Distributor
    add_index :distributors, :title, :unique => true

    # City
    add_index :cities, :name, :length => 8

    # District
    add_index :districts, :city_id

    # BusinessZone
    add_index :business_zones, [:district_id, :city_id]

    # Market
    add_index :markets, :name, :length => 10

    # MarketShop
    add_index :market_shops, [:business_zone_id, :market_id]

    # Distributor::Contract
    add_index :distributor_contracts, :code, :unique => true
    add_index :distributor_contracts, [:start_date, :end_date, :distributor_id]
    add_index :distributor_contracts, :distributor_id

    # Distributor::Shop    
    add_index :distributor_shops, [:business_zone_id, :district_id, :city_id]# :name => "by_biz_district_city"
    add_index :distributor_shops, :city_id
    add_index :distributor_shops, :market_shop_id

    # CouponFaq
    add_index :coupon_faqs, :faq_group_id

    # OffcerCoupon
    add_index :offer_coupons, [:city_id, :district_id]
    add_index :offer_coupons, :merchant

    # tag_amounts
    add_index :tag_amounts, :print_record_id

    # distributor_account_profiles
    add_index :distributor_account_profiles, [:distributor_id, :distributor_account_id], :unique => true

    # brands_production_categories
    add_index :brands_production_categories, [:brand_id, :production_category_id]
    add_index :brands_production_categories, :production_category_id

    # Complaint
    add_index :complaints, :coupon_id

    # Coupon
    add_index :coupons, :city_id
    add_index :coupons, :shop_id
    add_index :coupons, :distributor_id
    add_index :coupons, [:activity_end_at, :activity_began_at]
    add_index :coupons, [:tag_id, :brand_id]

  end

  def self.down
    # Distributor
    remove_index :distributors, :title

    # City
    remove_index :cities, :name

    # District
    remove_index :districts, :city_id

    # BusinessZone
    remove_index :business_zones, :column => [:district_id, :city_id]

    # Market
    remove_index :markets, :name

    # MarketShop
    remove_index :market_shops, :column => [:business_zone_id, :market_id]

    # Distributor::Contract
    remove_index :distributor_contracts, :code
    remove_index :distributor_contracts, :column => [:start_date, :end_date, :distributor_id]
    remove_index :distributor_contracts, :distributor_id

    # Distributor::Shop
    remove_index :distributor_shops, :column => [:business_zone_id, :district_id, :city_id]
    remove_index :distributor_shops, :city_id
    remove_index :distributor_shops, :market_shop_id

    # CouponFaq
    remove_index :coupon_faqs, :faq_group_id

    # OffcerCoupon
    remove_index :offer_coupons, :merchant
    remove_index :offer_coupons, :column => [:city_id, :district_id]

    # tag_amounts
    remove_index :tag_amounts, :print_record_id

    # distributor_account_profiles
    remove_index :distributor_account_profiles, :column => [:distributor_id, :distributor_account_id]

    # brands_production_categories
    remove_index :brands_production_categories, :column => [:brand_id, :production_category_id]
    remove_index :brands_production_categories, :production_category_id

    # Complaint
    remove_index :complaints, :coupon_id

    # Coupon
    remove_index :coupons, :city_id
    remove_index :coupons, :shop_id
    remove_index :coupons, :distributor_id
    remove_index :coupons, :column => [:activity_end_at, :activity_began_at]
    remove_index :coupons, :column => [:tag_id, :brand_id]
  end
end
