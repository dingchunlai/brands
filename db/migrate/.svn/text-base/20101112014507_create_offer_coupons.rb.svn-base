class CreateOfferCoupons < ActiveRecord::Migration
  def self.up
    create_table :offer_coupons do |t|
      t.string :merchant, :null => false, :limit => 50
      t.text :body, :null => false
      t.integer :city_id, :default => 0
      t.integer :district_id, :default => 0
      t.string :linkman, :null => false, :limit => 30
      t.string :telphone, :null => false, :limit => 30
      t.boolean :sex, :default => true
      t.integer :status, :default => 0
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :offer_coupons
  end
end
