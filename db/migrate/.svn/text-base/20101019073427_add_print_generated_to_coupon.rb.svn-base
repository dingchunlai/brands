class AddPrintGeneratedToCoupon < ActiveRecord::Migration
  def self.up
    add_column :coupons, :print_generated, :boolean, :default => false
  end

  def self.down
    remove_column :coupons, :print_generated
  end
end
