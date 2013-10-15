class CreateMarkets < ActiveRecord::Migration
  def self.up
    create_table :markets do |t|
      t.string :name, :null => false, :limit => 30
      t.boolean :deleted, :default => false
      t.integer :market_shops_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :markets
  end
end
