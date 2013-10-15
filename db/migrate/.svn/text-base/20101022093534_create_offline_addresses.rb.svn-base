class CreateOfflineAddresses < ActiveRecord::Migration
  def self.up
    create_table :offline_addresses do |t|
      t.integer :city_id
      t.integer :district_id
      t.string :address
      t.boolean :deleted, :default => false

    end
  end

  def self.down
    drop_table :offline_addresses
  end
end
