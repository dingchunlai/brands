class PaintContactsController < PaintApplicationController 
  
  helper PaintAdmin::ContactsHelper
  
  def index
    
  end
  
  def list
    @city, @province = params.values_at(:city, :province)
    @contacts = PaintContact.by_contact(params).paginate :page => params[:page], :per_page => 10
  end
  
  def chongtu
    
  end
  
  #得下省下的城市(ajax)
  def get_contacts_cities
    province = params[:province]
    cities = PaintContact.cities_for_province province
    render :json => cities
  end

  #
  def get_cities_duoleshi
    province = params[:province]
    cities = City.get_cities_for_province_douleshi province
    render :json =>cities
  end

end