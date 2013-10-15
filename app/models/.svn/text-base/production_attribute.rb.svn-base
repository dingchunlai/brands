class ProductionAttribute < ActiveRecord::Base
  belongs_to :category, :class_name => 'ProductionCategory'
=begin
  has_and_belongs_to_many :categories,
    :class_name => 'ProductionCategory',
    :join_table => 'production_attributes_production_categories',
    :foreign_key => 'production_attribute_id',
    :association_foreign_key => 'production_category_id'
=end

  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :category_id
end
