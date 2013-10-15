module ProductionsHelper
  def show_production_master_picture(production)
    if production && production.master_picture
      image_tag production.master_picture.public_filename
    else
      image_tag 'http://d.51hejia.com/api/images/none.gif'
    end
  end
end
