class CreateBusinessZones < ActiveRecord::Migration
  def self.up
    create_table :business_zones do |t|
      t.string :name, :null => false, :limit => 20
      t.string :pinyin, :null => false, :limit => 100
      t.string :code_name, :null => false, :limit => 30
      t.integer :city_id, :default => 0
      t.integer :district_id, :default => 0
      t.boolean :deleted, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :business_zones
  end
end
