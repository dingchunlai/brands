class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces do |t|
      t.string :name, :null => false, :limit => 8
      t.string :pinyin, :null => false, :limit => 50
      t.string :code_name, :null => false, :limit => 30
      t.integer :cities_count, :default => 0
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :provinces
  end
end
