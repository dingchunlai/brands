class AdminV2::WebPermissionsController < AdminV2Controller
  include TreeRender
  layout false
  def index
    authorize! :index, :web_permissions
    @roles = Ability::Role.all_names
    respond_to do |format|
      format.html
    end
  end
  
  def show
    authorize! :show, :web_permissions
    @role = Ability::Role.new(params[:id])
    @admin_permission = Ability::Permission.find_by_title('所有权限')
    @permissions = @role.permissions
    @groups = Ability::Permission::Group.all.group_by(&:parent_id)
    @all_permissions = Ability::Permission.all
    respond_to do |format|
      format.html
    end    
  end
  
  def update
    authorize! :update, :web_permissions
    if params[:type] == "all"
      role = Ability::Role.new(params[:id])
      permission = Ability::Permission.find_by_title('所有权限')
      if params[:op] == "add"
        Ability::Authority.destroy_all(:role_name => role.name)
        Ability::Authority.create(:role_name => role.name, :permission_id => permission.id)
      else
        auth = Ability::Authority.first(:conditions => ["role_name =? and permission_id = ?", role.name, permission.id])
        auth.destroy
      end
    else
      role = Ability::Role.new(params[:id])
      permission = Ability::Permission.find(params[:pid])
      if params[:op] == "add"
        Ability::Authority.create(:role_name => role.name, :permission_id => permission.id)
      else
        auth = Ability::Authority.first(:conditions => ["role_name =? and permission_id = ?", role.name, permission.id])
        auth.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_to elvuel_path(:id => params[:id]) }
      format.js {
        @role = Ability::Role.new(params[:id])
        @admin_permission = Ability::Permission.find_by_title('所有权限')
        @permissions = @role.permissions
        @groups = Ability::Permission::Group.all.group_by(& :parent_id)
        @all_permissions = Ability::Permission.all
        render :update do |page|
          page.replace_html 'tree_content', render_permission_tree(@groups, @all_permissions.group_by(& :group_id), @permissions.map(& :id))
          page << "$('#status').css('display', 'none');"
          if params[:type] == "all" and params[:op] == "add"
            page << '$("input[name^=\'permission_\']").attr("disabled", true);'
          end
          page << "add_link();"
          page << '$(function() {
          $("#tree").treeview({
              collapsed: false,
              animated: "medium",
              control:"#sidetreecontrol",
              persist: "location"
          });
      });'
        end
      }
    end

  end

  def create_group
    authorize! :create_group, :web_permissions
    @group = Ability::Permission::Group.new(params[:ability_permission_group])
    respond_to do |format|
      if @group.save
        format.js {  }
      else
        @group.errors.add("保存失败!")
        format.js {  }
      end
    end
  end

  def create_permission
    authorize! :create_group, :web_permissions
    subject_class = params[:ability_permission][:subject_class]

    params[:ability_permission][:subject_class] = subject_class.constantize if subject_class =~ /^[A-Z]/

    @permission = Ability::Permission.new(params[:ability_permission])
    respond_to do |format|
      if @permission.save
        format.js {  }
      else
        @group.errors.add("保存失败!")
        format.js {  }
      end
    end
  end


  def fetch_permission
    permission = Ability::Permission.find(params[:id])
    respond_to do |format|
      format.json { render :json => permission.to_json(:except => :subject_class, :methods => :subject_class_name) }
    end
  end

  def update_permission
    authorize! :update_permission, :web_permissions
    @permission = Ability::Permission.find(params[:edit_permission_id])
    subject_class = params[:edit_ability_permission][:subject_class]

    params[:edit_ability_permission][:subject_class] = subject_class.constantize if subject_class =~ /^[A-Z]/

    respond_to do |format|
      if @permission.update_attributes(params[:edit_ability_permission])
        format.js { }
      else
        @permission.errors.add("更新失败!")
        format.js { }
      end
    end
  end


end