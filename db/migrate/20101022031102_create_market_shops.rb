class CreateMarketShops < ActiveRecord::Migration
  def self.up
    create_table :market_shops do |t|
      t.string :name, :null => false, :limit => 30
      t.integer :city_id, :default => 0
      t.integer :district_id, :default => 0
      t.integer :business_zone_id, :default => 0
      t.integer :market_id, :default => 0
      t.string :address, :limit => 150
      t.string :telphone, :limit => 30
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :market_shops
  end
end
