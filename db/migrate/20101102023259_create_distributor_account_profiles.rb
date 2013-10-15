class CreateDistributorAccountProfiles < ActiveRecord::Migration
  def self.up
    create_table :distributor_account_profiles do |t|
      t.integer :distributor_id
      t.integer :distributor_account_id

    end
  end

  def self.down
    drop_table :distributor_account_profiles
  end
end
