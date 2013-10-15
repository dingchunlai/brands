class CreatePrivilegeActions < ActiveRecord::Migration
  def self.up
    create_table :privilege_actions do |t|
      t.string :action
      t.string :action_chinese
      t.string :model
      t.string :model_chinese
      t.string :controller

      t.timestamps
    end
  end

  def self.down
    drop_table :privilege_actions
  end
end
