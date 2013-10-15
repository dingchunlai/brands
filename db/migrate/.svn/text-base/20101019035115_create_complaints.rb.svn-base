class CreateComplaints < ActiveRecord::Migration
  def self.up
    create_table :complaints do |t|
      t.integer :coupon_id
      t.string :coupon_code, :limit => 50
      t.string :title, :limit => 100
      t.string :name, :limit => 30
      t.string :telphone, :limit => 20
      t.string :email, :limit => 100
      t.string :address, :limit => 150
      t.text :body
      t.string :description, :limit => 200
      t.boolean :is_valid, :null => true
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :complaints
  end
end
