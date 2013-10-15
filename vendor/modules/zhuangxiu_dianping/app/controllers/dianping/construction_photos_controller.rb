class Dianping::ConstructionPhotosController < Dianping::ApplicationController
  #施工图片
  def index
   @photos = DecoPhoto.all_for_deco_firm(@user_city_code).paginate :page=>params[:page], :per_page => 24
   expires_in 5.minutes, :public => true
  end
  
end