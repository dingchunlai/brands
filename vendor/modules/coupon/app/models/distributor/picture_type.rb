# encoding : utf-8

class Distributor::PictureType < Hejia::Db::Product
  # distributor_id:integer class_name:string created_at:datetime updated_at:datetime
  belongs_to :distributor
  has_many :pictures, :class_name => "Distributor::UploadPicture", :as => :resource

  class Shop < Distributor::PictureType
    set_inheritance_column :class_name
  end

  class Case < Distributor::PictureType
    set_inheritance_column :class_name
  end

  class Glory < Distributor::PictureType
    set_inheritance_column :class_name
  end
  
end