class CreateRoleAbilities < ActiveRecord::Migration
  def self.up
    create_table :role_abilities do |t|
      t.integer :role_id
      t.integer :operation
      t.string :object
      t.timestamps
    end
  end

  def self.down
    drop_table :role_abilities
  end
end
