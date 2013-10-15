require_dependency 'coupon'

class Admin::PrintPropertiesController < Coupon::AdminController
 
  def edit
    authorize! :edit, :print_properties    
    if params[:city_id].to_s.empty?
      @industry_color = @area_color = @industries = @footer = ''      
    else
      city = City.find(params[:city_id])
      @city_key = city.name
      props = $redis.get print_properties_key
      if props.to_s.empty?
        industry_colors = Tag.all_categories.map(& :short_name)
        @industry_color = Hash[* industry_colors.to_a.collect { |v| [v, rand_color] }.flatten].ya2yaml(:syck_compatible => true)
        area_colors = city.districts.collect { |district| "#{district.code_name}" }
        @area_color = Hash[* area_colors.to_a.collect { |v| [v, rand_color] }.flatten].ya2yaml(:syck_compatible => true)
        @industries = Tag.all_categories.map(& :short_name).ya2yaml(:syck_compatible => true)
        #① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨
        @footer = "使用方法: ①此为无条件现金抵用券,请与商家砍价后拿出使用 ②更多抵用券查询: q.51hejia.com ③如商家未抵用,请投诉:400-602-5151".ya2yaml(:syck_compatible => true)
      else
        hash = YAML::load(props)
        @industry_color = hash['industry_color'].ya2yaml(:syck_compatible => true)
        @area_color = hash['area_color'].ya2yaml(:syck_compatible => true)
        @industries = hash['industries'].ya2yaml(:syck_compatible => true)
        @footer = hash['footer'].ya2yaml(:syck_compatible => true)
      end
    end
    
  end

  def create
    authorize! :create, :print_properties
    if params[:print_properties][:city_id].to_s.empty?
      redirect_to(edit_admin_print_properties_path, :alert => '请选择城市！')
      return
    else
      city_id = params[:print_properties].delete(:city_id)
      city = City.find(city_id)
      @city_key = city.name
      yml = {}
      params[:print_properties].keys.each { |key| yml[key.to_s] = YAML::load(params[:print_properties][key.to_sym]) }
      begin
        $redis.set print_properties_key, yml.ya2yaml(:syck_compatible => true)
        redirect_to(edit_admin_print_properties_path(:city_id => city_id), :notice => '当前城市更新成功!')
      rescue
        redirect_to(edit_admin_print_properties_path(:city_id => city_id), :alert => '当前城市更新更新失败!')
      end
    end
    
  end

  private
  def print_properties_key
    "coupon:print_properties:#{@city_key}"
  end

  def rand_color
    hex = (0..9).to_a.concat(('A'..'F').to_a)
    color = 6.times.collect { |i| hex[rand(hex.size)] }.join
    "##{color}"
  end


end
