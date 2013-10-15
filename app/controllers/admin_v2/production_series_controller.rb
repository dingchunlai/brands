class AdminV2::ProductionSeriesController < AdminV2Controller
  
  def index
    #获取产品系列
    @production_serieses = ProductionSeries.paginate :page => page
    
  end
  
  def destroy
    
    ProductionSeries.delete params[:id]
    
    redirect_to :action => :index 
    
  end
  
  def edit
    
    @production_series = ProductionSeries.find params[:id]
    
  end
  
  def update
    
    @production_series =  ProductionSeries.find params[:id]
    
    @production_series.name = params[:production_series][:name]
    
    @production_series.brand_id = params[:production_series][:brand_id]
    
    @production_series.save
    
    redirect_to :action => :index 
    
  end
  
  def new
    
    @production_series =  ProductionSeries.new
    
  end
  
  def create
    
    @production_series =  ProductionSeries.new(params[:production_series])
    
    @production_series.save
    
    redirect_to :action => :index
    
  end
  
  
end
