module ProductionCategoryHelper
  extend ActiveSupport::Memoizable

  def production_category_select_collection
    ProductionCategory.all(:select => 'id, name').map { |category| [category.name, category.id] }
  end
  memoize :production_category_select_collection
end
