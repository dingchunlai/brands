class GeneralResource < ActiveRecord::Base

  include Hejia::Promotable
  promotion_method_alias :title, :title
  promotion_method_alias :description, :description
  promotion_method_alias :content, :content
  promotion_method_alias :url, :url

  def image_url
    img = read_attribute("image_url")
    img = "/4c5256918686970a6a000419-047ef5e9d2a5d81695961cd781f62f77.jpg" if img.blank?
    img
  end
  
end
