class CreateCouponPrintProperties < ActiveRecord::Migration
  def self.up
    create_table :coupon_print_properties do |t|
      t.integer :coupon_id, :null => false
      t.text :properties, :null => false
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_print_properties
  end
end
