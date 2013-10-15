class AddTagidToProductionCategory < ActiveRecord::Migration
  def self.up
    add_column :production_categories, :tag_id, :integer
  end

  def self.down
    remove_column :production_categories, :tag_id
  end
end
