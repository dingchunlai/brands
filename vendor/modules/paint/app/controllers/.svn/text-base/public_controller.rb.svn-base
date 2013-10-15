class PublicController < PaintApplicationController
  
  skip_filter :auto_expire, :except => [:get_city_json]
  
  def get_city_json
    render :json => City.get_cities_for_province_jinshuazi(params[:province])
  end
  
  def jump
    redirect_to 'http://www.51hejia.com'
  end
  
end
