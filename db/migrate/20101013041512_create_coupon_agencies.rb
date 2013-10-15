class CreateCouponAgencies < ActiveRecord::Migration
  def self.up
    create_table :distributors do |t|
      t.string :title, :null => false, :limit => 50
      t.string :short_title, :null => false, :limit => 20
      t.string :code, :limit => 15
      t.boolean :deleted, :default => false
      t.integer :complaints_count, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :distributors
  end
end
