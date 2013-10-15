require_dependency 'coupon/admin_controller'
class Admin::Coupon::IndexController < Coupon::AdminController

  def index
    distributor_ids = Distributor.with_contracts(current_ability_user.owned_contracts).map(&:id).uniq
    # 经销商数量
    @distributors_count = if can?(:read, Distributor)
      Distributor.valid_count 
    elsif can?(:read_owned_distributors, Distributor)
      Distributor.valid_count(distributor_ids)
    else
      0
    end
    # 门点数量
    @shops_count = if can?(:read, Distributor::Shop)
      Distributor::Shop.valid_count 
    elsif can?(:read_owned_shops, Distributor::Shop)
      Distributor::Shop.valid_count(distributor_ids)
    else
      0
    end
    # 合同数量
    @valid_contracts_count = if can?(:read, Distributor::Contract)
      Distributor::Contract.valid_count 
    elsif can?(:read_owned_contracts, Distributor::Contract)
      Distributor::Contract.valid_count(current_ability_user.owned_contracts)
    else
      0
    end
    #@complaints_count = Complaint.valid_count
    # 抵用券数量
    @coupons_count = if can?(:read, Coupon)
      Coupon.valid_count
    elsif can?(:read_owned_coupons, :coupons)
      # params[1] city
      # params[2] distributor_ids TYPE_OF array
      Coupon.valid_count(nil, distributor_ids)
    else
      0
    end
  end

end
