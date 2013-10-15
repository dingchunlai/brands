class FeaturesController < ApplicationController

  layout :set_layout  
  
  include CityCode
  before_filter :current_city_code, :export => [:news]
  helper :features
  helper Dianping::ApplicationHelper
  helper DecoFirmHelper

  def glory
    city_code = TAGURLS[@user_city_code.to_i]
    @city_name = CITIES[@user_city_code.to_i]
    unless Features::PromotedCompany.find(city_code, params[:date]).blank?
      @companies = []
      Features::PromotedCompany.find(city_code, params[:date]).each do |id|
        @companies << DecoFirm.find_by_id(id.to_i) if DecoFirm.find_by_id(id.to_i)
      end
    else
      return page_not_found!
    end
  end

  def free
    unless @user_city_code.to_i == 11910
      @city_name = CITIES[@user_city_code.to_i]
      @city_pinyin = TAGURLS[@user_city_code.to_i]
      page = params[:page].to_i == 0 ? 1 : params[:page].to_i
      @factories = CaseFactoryCompany.with_city(@user_city_code).paginate :order => 'STARTENABLE desc', :per_page => 9, :page => page 
      @fdatas = ActiveRecord::Base.connection.select_all("select c1, c2, c3, c4, c5, c6 from 51hejia.radmin_fdatas where formid = #{TURN_ID_FOR_CITY[@city_pinyin]} and c7 = '#{@city_pinyin}'")
    else
      return page_not_found!
    end
  end

  def news
    @date = params[:date]
    return head(404) if @date != '201105'
  end

  private
    def set_layout
      if action_name == "free"
        false
      elsif action_name == "glory"
        'features' 
      else
        false
      end
    end

end
