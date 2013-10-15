class CreateCouponDownloads < ActiveRecord::Migration
  def self.up
    create_table :coupon_downloads do |t|
      t.integer :coupon_id, :default => 0, :null => false
      t.string :mobile, :null => false, :limit => 11
      t.boolean :is_confirm, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_downloads
  end
end
