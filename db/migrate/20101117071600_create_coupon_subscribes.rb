class CreateCouponSubscribes < ActiveRecord::Migration
  def self.up
    create_table :coupon_subscribes do |t|
      t.integer :city_id
      t.integer :tag_id
      t.string :email, :limit => 80

    end
  end

  def self.down
    drop_table :coupon_subscribes
  end
end
