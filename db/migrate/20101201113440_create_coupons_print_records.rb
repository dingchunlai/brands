class CreateCouponsPrintRecords < ActiveRecord::Migration
  def self.up
    create_table :coupons_print_records do |t|
      t.integer :coupon_id
      t.integer :print_record_id

    end
  end

  def self.down
    drop_table :coupons_print_records
  end
end
