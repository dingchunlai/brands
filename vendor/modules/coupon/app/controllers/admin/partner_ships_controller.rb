require_dependency 'coupon/admin_controller'
class Admin::PartnerShipsController < Coupon::AdminController
  
  load_and_authorize_resource
  def index
    @partner_ships = PartnerShip.paginate(:page => ((params[:page].to_i==0)? 1 : params[:page].to_i), :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @partner_ship = PartnerShip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @partner_ship = PartnerShip.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @partner_ship = PartnerShip.find(params[:id])
  end

  def create
    @partner_ship = PartnerShip.new(params[:partner_ship])
    @partner_ship.code = ActiveSupport::SecureRandom.hex(8)
    @partner_ship.activity_begin_at = Time.zone.today - 1
    @partner_ship.activity_end_at = Time.zone.today - 1.year
    
    respond_to do |format|
      if @partner_ship.save
        format.html { redirect_to(admin_partner_ships_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @partner_ship = PartnerShip.find(params[:id])

    respond_to do |format|
      if @partner_ship.update_attributes(params[:partner_ship])
        format.html { redirect_to(admin_partner_ship_path(@partner_ship)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @partner_ship = PartnerShip.find(params[:id])
    @partner_ship.mark_deleted
    
    respond_to do |format|
      format.html { redirect_to(admin_partner_ships_path) }
    end
  end

end
