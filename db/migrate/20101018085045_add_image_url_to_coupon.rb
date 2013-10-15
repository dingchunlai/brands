class AddImageUrlToCoupon < ActiveRecord::Migration
  def self.up
    add_column :coupons, :image_url, :string, :limit => 200
  end

  def self.down
    remove_column :coupons, :image_url
  end
end
