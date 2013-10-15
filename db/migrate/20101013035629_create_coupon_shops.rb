class CreateCouponShops < ActiveRecord::Migration
  def self.up
    create_table :distributor_shops do |t|
      t.string :name, :null => false, :limit => 50
      t.references :distributor
      t.integer :city_id
      t.integer :district_id
      t.integer :business_zone_id
      t.integer :market_shop_id
      t.string :linkman, :limit => 30
      t.string :address, :limit => 100
      t.string :telphone, :limit => 50
      t.float :latitude
      t.float :longitude
      t.string :googlemap_image_url
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :distributor_shops
  end
end
