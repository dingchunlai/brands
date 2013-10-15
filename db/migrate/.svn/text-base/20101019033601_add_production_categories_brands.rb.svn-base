class AddProductionCategoriesBrands < ActiveRecord::Migration

  def self.up
    create_table :brands_production_categories do |t|
      t.integer :brand_id
      t.integer :production_category_id

    end
  end

  def self.down
    drop_table :brands_production_categories
  end

end
