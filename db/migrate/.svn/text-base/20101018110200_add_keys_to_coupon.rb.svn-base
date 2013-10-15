class AddKeysToCoupon < ActiveRecord::Migration
  def self.up
    add_column :coupons, :tag_id, :integer, :default => 0
    add_column :coupons, :brand_id, :integer, :default => 0
  end

  def self.down
    remove_column :coupons, :tag_id
    remove_column :coupons, :brand_id
  end
end
