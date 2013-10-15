module HuodongHelper

  def list_url(city='', tagurl='', scope='')
    str = ''
    str += city unless city.blank?
    str += "_#{tagurl}" unless tagurl.blank?
    path = huodong_list_path(str).chomp('/') + '/'
    path += "?scope=#{scope}" unless scope.blank?
    return path
  end

end
