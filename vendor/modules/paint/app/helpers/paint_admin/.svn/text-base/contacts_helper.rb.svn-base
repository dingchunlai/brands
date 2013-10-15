module PaintAdmin::ContactsHelper
  
  #得到省份
  def get_province
    provinces = PaintContact.get_province
    province_array = []
    provinces.each do |code|
      province_array << [Province.name_for_code(code.province), code.province]
    end
    province_array
  end
  
  #得到省份下的城市城市
  def get_cities province
    PaintContact.cities_for_province province  
  end
  
end
