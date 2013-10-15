class AddCounterCacheColumnToRelModel < ActiveRecord::Migration
  def self.up
    add_column :distributors, :coupons_count, :integer, :default => 0
    add_column :distributors, :shops_count, :integer, :default => 0
    add_column :distributors, :contracts_count, :integer, :default => 0

  end

  def self.down
    remove_column :distributors, :coupons_count
    remove_column :distributors, :shops_count
    remove_column :distributors, :contracts_count
  end
end
