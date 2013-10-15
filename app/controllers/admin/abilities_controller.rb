class Admin::AbilitiesController < AdminController

  def index
    @role_id = params[:role_id].blank? ? 1 : params[:role_id].to_i
    @abilitys = RoleAbility.by_role(@role_id).paginate :per_page => 30, :page => page
  end

  def new
    @ability = RoleAbility.new
    render :action => :edit
  end

  def create
    @ability = RoleAbility.new(params[:role_ability])
    if @ability.save
      redirect_to admin_abilities_path + "?role_id=#{@ability.role_id}", :notice => '记录添加成功'
    else
      index
      render :action => :index
    end
  end

  def edit
    @ability = RoleAbility.find(params[:id])
  end

  def update
    @ability = RoleAbility.find(params[:id])
    if @ability.update_attributes(params[:role_ability])
      redirect_to admin_abilities_path + "?role_id=#{@ability.role_id}", :notice => '记录更新成功'
    else
      index
      render :action => :index
    end
  end

  def destroy
    @ability = RoleAbility.find(params[:id])
    role_id = @ability.role_id
    @ability.destroy
    redirect_to admin_abilities_path + "?role_id=#{role_id}&page=#{page}"
  end

end
