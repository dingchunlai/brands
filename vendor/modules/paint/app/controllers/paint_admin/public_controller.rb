class PaintAdmin::PublicController < PaintAdmin::AdminController
  
  def get_province
    render :json => Province.get_province_douleshi.to_a
  end
  
  def get_city_json
    render :json => City.get_cities_for_province_douleshi(params[:province]).to_a
  end
  
end