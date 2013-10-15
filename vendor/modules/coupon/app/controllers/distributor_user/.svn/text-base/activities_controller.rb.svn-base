# encoding: utf-8
require_dependency 'coupon'
class DistributorUser::ActivitiesController < Coupon::DistributorUserController

  def index
    @activities = VipDistributorActivity.paginate(
        :all,
        :conditions => ["distributor_id = ?", @current_distributor.id],
        :per_page => 12,
        :page => ((params[:page].to_i==0)? 1 : params[:page].to_i)
    )

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @activity = VipDistributorActivity.find(params[:id])
    raise CanCan::AccessDenied if @activity.distributor_id != @current_distributor.id
    @images = @activity.pictures.paginate(
        :all,
        :order => "id desc",
        :per_page => 10,
        :page => ((params[:page].to_i==0)? 1 : params[:page].to_i)
    )
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @activity = VipDistributorActivity.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /vip_distributor_activities/1/edit
  def edit
    @activity = VipDistributorActivity.find(params[:id])
    raise CanCan::AccessDenied if @activity.distributor_id != @current_distributor.id
  end

  # POST /vip_distributor_activities
  # POST /vip_distributor_activities.xml
  def create
    @activity = VipDistributorActivity.new(params[:vip_distributor_activity].update(:distributor_id => @current_distributor.id))

    respond_to do |format|
      if @activity.save
        format.html { redirect_to(distributor_user_activity_path(@activity), :notice => '活动添加成功！') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /vip_distributor_activities/1
  # PUT /vip_distributor_activities/1.xml
  def update
    @vip_distributor_activity = VipDistributorActivity.find(params[:id])
    raise CanCan::AccessDenied if @vip_distributor_activity.distributor_id != @current_distributor.id

    respond_to do |format|
      if @vip_distributor_activity.update_attributes(params[:vip_distributor_activity].update(:distributor_id => @current_distributor.id))
        format.html { redirect_to(distributor_user_activity_path(@vip_distributor_activity), :notice => '活动更新成功！') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /vip_distributor_activities/1
  # DELETE /vip_distributor_activities/1.xml
  def destroy
    @vip_distributor_activity = VipDistributorActivity.find(params[:id])
    raise CanCan::AccessDenied if @vip_distributor_activity.distributor_id != @current_distributor.id
    @vip_distributor_activity.mark_deleted

    respond_to do |format|
      format.html { redirect_to(distributor_user_activities_path) }
    end
  end
end