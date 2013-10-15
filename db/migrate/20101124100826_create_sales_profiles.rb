class CreateSalesProfiles < ActiveRecord::Migration
  def self.up
    create_table :sales_profiles do |t|
      t.integer :user_id
      t.integer :manager_id
      t.integer :city_id
      t.string :qq
      t.string :mobile
      t.string :email
      t.string :telephone

    end
  end

  def self.down
    drop_table :sales_profiles
  end
end
