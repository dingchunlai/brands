class CreateCouponLeafletPoints < ActiveRecord::Migration
  def self.up
    create_table :coupon_leaflet_points do |t|
      t.string :name
      t.string :address, :null => false
      t.string :telephone
      t.string :shop_name
      t.string :linkman
      t.integer :city_id, :null => false
      t.integer :district_id, :null => false
      t.boolean :deleted, :default => false
      t.date :activity_begin_at, :null => false
      t.date :activity_end_at, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_leaflet_points
  end
end
