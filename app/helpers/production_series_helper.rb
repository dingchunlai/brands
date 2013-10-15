module ProductionSeriesHelper
  extend ActiveSupport::Memoizable

  def production_series_select_collection
    ProductionSeries.all(:select => 'id, name').map { |series| [series.name, series.id] }
  end
  memoize :production_series_select_collection
end
