class ProductionSeries < ActiveRecord::Base
  belongs_to :brand

  has_many :productions, :dependent => :nullify
  
  def update_ production_series
    
  end
end
