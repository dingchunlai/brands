class CreateCouponCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :title, :null => false, :limit => 150
      t.integer :discount_amount
      t.integer :return_amount
      t.integer :discount_rate, :default => 0
      t.integer :city_id, :default => 0
      t.references :shop
      t.references :distributor
      t.integer :contract_id
      t.integer :pv, :default => 0
      t.integer :prints_count, :default => 0
      t.integer :downloads_count, :default => 0
      t.string :sms_msg, :limit => 150
      t.datetime :activity_began_at
      t.datetime :activity_end_at
      t.string :usage, :limit => 400
      t.boolean :offline_event, :default => false
      t.string :offline_address, :limit => 100
      t.integer :offline_out_count, :default => 0
      t.boolean :deleted, :default => false
      t.integer :remarks_count, :default => 0
      t.string :seo_keywords, :limit => 150
      t.string :seo_description
      t.string :seo_title, :limit => 150
      t.integer :sort, :default => 0
      t.integer :complaints_count, :default => 0
      t.boolean :is_hidden, :default => false
      t.datetime :penalty_deadline
      t.string :print_image_url, :limit => 100
      t.string :montage_image_url, :limit => 100
      t.integer :status, :default => 0


      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
