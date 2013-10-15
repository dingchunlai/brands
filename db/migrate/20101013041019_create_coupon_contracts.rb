class CreateCouponContracts < ActiveRecord::Migration
  def self.up
    create_table :distributor_contracts do |t|
      t.string :title, :null => false
      t.datetime :start_date
      t.datetime :end_date
      t.references :distributor
      t.string :code
      t.string :description
      t.boolean :deleted, :default => false
      t.integer :radmin_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :distributor_contracts
  end
end
