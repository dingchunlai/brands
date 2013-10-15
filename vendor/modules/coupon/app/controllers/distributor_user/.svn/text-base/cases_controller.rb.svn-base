# encoding: utf-8
require_dependency 'coupon'
class DistributorUser::CasesController < Coupon::DistributorUserController
  def index
    @cases = VipDistributorCase.paginate(
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
    @case = VipDistributorCase.find(params[:id])
    raise CanCan::AccessDenied if @case.distributor_id != @current_distributor.id

    @images = @case.pictures.paginate(
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
    @case = VipDistributorCase.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @case = VipDistributorCase.find(params[:id])
    raise CanCan::AccessDenied if @case.distributor_id != @current_distributor.id
  end

  def create
    @case = VipDistributorCase.new(params[:vip_distributor_case].update(:distributor_id => @current_distributor.id))

    respond_to do |format|
      if @case.save
        format.html { redirect_to(distributor_user_case_path(@case), :notice => '案例添加成功') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @case = VipDistributorCase.find(params[:id])
    raise CanCan::AccessDenied if @case.distributor_id != @current_distributor.id

    respond_to do |format|
      if @case.update_attributes(params[:vip_distributor_case].update(:distributor_id => @current_distributor.id))
        format.html { redirect_to(distributor_user_case_path(@case), :notice => '案例更新成功') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @case = VipDistributorCase.find(params[:id])
    raise CanCan::AccessDenied if @case.distributor_id != @current_distributor.id
    @case.mark_deleted

    respond_to do |format|
      format.html { redirect_to(distributor_user_cases_path) }
    end
  end
end