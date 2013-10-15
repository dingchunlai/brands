class CreateCouponRecommendations < ActiveRecord::Migration
  def self.up
    create_table :coupon_recommendations do |t|
      t.integer :coupon_id
      t.string :name
      t.string :email, :limit => 100

    end
  end

  def self.down
    drop_table :coupon_recommendations
  end
end
