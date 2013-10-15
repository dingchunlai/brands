class BrandPicture < ActiveRecord::Base
  set_table_name "product_brand_images"
  
  belongs_to :brand

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :path_prefix => "public/images/brands",
                 :max_size => 500.kilobytes
                 #:resize_to => '320x200',
                 #:thumbnails => { :thumb => '120x80', :medium => '240x160' },
                 #:processor => :Rmagick

  validates_as_attachment

=begin
  def full_path
    path_prefix = BRAND_LOGO_PATH_PREFIX
    path = ""
    path << path_prefix
    path << self.filename
    return path
  end
=end
end
