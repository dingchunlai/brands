require_dependency 'coupon/admin_controller'
class Admin::LocationRelateModelsController < Coupon::AdminController
  
  
  
  def relate_new
    if params[:model_type] and params[:model_type] == "jinshazi"
      @cfm = LocationRelateModel::JINSHAZI_FOR_MODEL
    else
      @cfm = LocationRelateModel::CITY_FOR_MODEL
    end
    @model_type = params[:model_type]
    @location_id = params[:location_id]
    @province = Province.find(@location_id)
    @location_relate_model = LocationRelateModel.new
    render :layout =>  false
  end
  
  def create_all
    cities = params[:relate_cities].nil? ? [] : params[:relate_cities]
    proince_relate = LocationRelateModel.new params[:location_relate_model]
    model_name = proince_relate.model_name
    model_check = params[:model_check]
    #省份的记录
    province = Province.find(proince_relate.resource_id)
    if model_check.to_i == 0 #如果没有选中,删除这条记录
      LocationRelateModel.delete(province.location_relate_model.get_relate_for_model(model_name).find(:first,:select => "id"))
    else #选中了,创建这条记录
      Province.find(proince_relate.resource_id).location_relate_model.create(:model_name => model_name)
    end
     
    #省份下城市的记录
    province.cities.each do |city|
      city_relate = city.location_relate_model.get_relate_for_model(model_name).first
      #首先判断数据库里有没有这个城市的记录
      #1.如果有: 如果这个城市不在选中的这个城市中.那么删除.其它不管
      #2.如果没有 : 如果这个城市在选中的城市中,那么添加.其它不管
      if city_relate
        LocationRelateModel.delete(city_relate.id) unless cities.include? city.id.to_s
      else
        city.location_relate_model.create(:model_name => model_name) if cities.include? city.id.to_s
      end
    end
    render :json => {:resule => true}
  end
  
end