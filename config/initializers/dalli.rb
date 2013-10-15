# encoding: utf-8
# @author Gimi Liang

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # Only works with DalliStore
    if defined?(ActiveSupport::Cache::DalliStore) && Rails.cache.is_a?(ActiveSupport::Cache::DalliStore)
      Rails.cache.reset if forked
    end
  end
end
