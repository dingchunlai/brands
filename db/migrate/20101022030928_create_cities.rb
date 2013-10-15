class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name, :null => false, :limit => 8
      t.string :pinyin, :null => false, :limit => 50
      t.string :code_name, :null => false, :limit => 30
      t.integer :districts_count, :default => 0
      t.integer :province_id, :default => 0
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :cities
  end
end
