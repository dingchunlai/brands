# -*- coding: utf-8 -*-
class RemoteController < ApplicationController

  layout nil

  def ajax_get
    send params[:t]
  end

  # 返回所有属于某个城市的地区
  def districts
    districts = District.by_city(params[:id]).map{|d| [d.name, d.id]}
    respond_to do |format|
      format.json { render :json => districts }
    end
  end

  def assign_contracts
    if params[:from_user] && params[:to_user]
      #Message.update_all({:read => true}, {:id => user.messages})
      rusers = RadminUser.find(:all, :conditions => ["id in (?)", [params[:from_user].to_i, params[:to_user].to_i]])
      if rusers.size == 2
        #Billing.update_all({:author => author},['title like ?', "#{prefix}%"])
        result = Distributor::Contract.update_all({:radmin_user_id => params[:to_user].to_i, :updated_at => Time.zone.now }, ["radmin_user_id = ?", params[:from_user]])
        render :text => "操作完成，重新分配 #{result} 条数据!"
      else
        render :text => "错误,请选择有效的业务员!"
      end
    else
      render :text => "错误,请选择业务员!"
    end
  end

  def categories
    categories = ProductionCategory.for_tag params[:id]
    respond_to do |format|
      format.json { render :json => categories }
    end
  end

  def entrust
    entrust = CouponEntrustAgreement.find(params[:id])
    respond_to do |format|
      format.json { render :json => entrust }
    end
  end

  # 返回属于某个地区的商圈
  def business_zones
    zones = BusinessZone.by_district(params[:id]).map{|d| [d.name, d.id]}
    respond_to do |format|
      format.json { render :json => zones }
    end
  end

  #根据地区与商圈查询卖场分店
  def market_shops
    business_zone_id, district_id = params[:id].to_i, params[:district_id].to_i
    shops = MarketShop.by_district(district_id)
    shops = shops.by_business_zone(business_zone_id)
    render :json => shops.map{|d| [d.market_name + d.name, d.id]}
  end

  # 根据卖场查找 卖场下的所有分店
  def market_shops_for_market
    market = Market.find_by_id params[:id]
    unless market.blank?
      shops = market.market_shops.map{|d| [d.name, d.id]}
    else
      shops = []
    end
    respond_to do |format|
      format.json { render :json => shops }
    end
  end

  def market_shops_by_district
    shops = MarketShop.by_district(params[:id]).map{|d| [d.name, d.id]}
    render :json => shops
  end
 
  def markets_by_market_shop_ids
    market_shop_ids = params[:market_shop_ids].to_s.split(',')
    return render :json => [] if market_shop_ids.length == 0
    market_ids = MarketShop.all(:select => 'market_id', :conditions => ['id in (?)', market_shop_ids]).map{|s| s.market_id}
    markets = market_ids.length > 0 ? Market.all(:select => 'id, name', :conditions => ['id in (?)', market_ids]) : []
    render :json => markets.map{|m| [m.name, m.id] }
  end

  def check_coupon_exist
    coupon = Coupon.first(:conditions => ["code = ?", params[:code]], :select => "id, code")
    respond_to do |format|
      format.json { render :json => coupon.to_json }
    end
  end

  #返回属于某个经销商的合同s
  def contracts
    #cs = Distributor::Contract.by_distributor(params[:id]).valid.map{|d| [d.title, d.id]}
    cs = Distributor::Contract.valid_contracts(params[:id]).map{|d| [d.title, d.id]}
    render :json => cs.empty? ? [['没有合同','']] : cs.unshift(['请选择',''])
  end

  # 取得某一个合同对象 
  def contract
    cs = Distributor::Contract.find_by_id params[:id]
    render :json => cs
  end


  def distributors_by_title
    q = params[:q].to_s.strip
    #render :json => q.blank? ? ''.to_json : Distributor.search(q).map{ |d| [d.title, d.id] }.to_json
    if q.blank?
      render :json => [].to_json
    else
      render :json => Distributor.search(q).to_json
    end
  end

  #判断用户是否已经存在
  def username_exists
    username = params[:id].to_s
    user = username.split(//u).length < 3 ? nil : HejiaUserBbs.first(:select => 'USERBBSID', :conditions => ['USERNAME = ?', username])
    render :text => "#{params[:callback]}(#{user && 1 || 0});"
  end

  #判断用户Email地址是否已经存在
  def user_email_exists
    email = params[:email].to_s
    user = email.split(//u).length < 6 ? nil : HejiaUserBbs.first(:select => 'USERBBSID', :conditions => ['USERBBSEMAIL = ?', email])
    render :text => "#{params[:callback]}(#{user && 1 || 0});"
  end

  #抵用券状态修改
  def change_coupon_status
    coupon_id, statu = params[:id].to_i, params[:statu].to_i
    return false if coupon_id == 0 || statu == 0
    coupon = ::Coupon.find(coupon_id) rescue nil
    if coupon
      coupon.status = statu
      coupon.save
    end
    forward = request.env['HTTP_REFERER'].to_s
    forward = admin_coupons_path if forward.blank?
    redirect_to forward
  end

  #根据 名称 查询装修公司
  def decofirm_by_name
    keyword = params[:q].to_s.strip
    render :json => keyword.blank? ? '' : DecoFirm.find(:all, :conditions => ["name_zh like ? and (state=50 OR state = 100)", "%#{keyword}%"], :limit => 20, :select => "id, name_zh").to_json
  end

end
