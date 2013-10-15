# encoding: utf-8

class Api::AjaxController < Api::BaseController
  include IpHelper
  helper 
  caches_action :cases, :cache_path => Proc.new { |c| c.pathx }, :expires_in => 5.minutes
  caches_action :diaries, :cache_path => Proc.new { |c| c.diaries_pathx }, :expires_in => 5.minutes
  caches_action :companies, :cache_path => Proc.new { |c| c.pathx }, :expires_in => 5.minutes
  caches_action :company_and_case, :cache_path => Proc.new { |c| c.pathx }, :expires_in => 5.minutes
  
  before_filter :find_city_id
  before_filter :find_companies, :only => [:companies, :company_and_case]
  
  def pathx
     "#{action_name}:#{remote_city[:number].to_s}"
  end
  
  def diaries_pathx
      "#{action_name}:#{remote_city[:number].to_s}:#{params[:style_id]}"
   end
  
  def cases
    @cases =  HejiaCase.find(:all,
        :conditions => ["STATUS != '-100' and ISNEWCASE = 1 and ISZHUANGHUANG = '1' and TEMPLATE != 'room' and ISZHUANGHUANG='1' and (deco_firms.city = ? or deco_firms.district = ?) ",@city_id, @city_id],
        :joins => "join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id",
        :order => "CREATEDATE desc", :limit=>4
        ).collect{|c| {:url => c.url, :image_url => c.master_picture_url, :title => c.NAME} }
    @result = {:cases => @cases, :city_name => @city_name}
    render :text => %{$( "#casesTemplate" ).tmpl( #{@result.to_json} ).appendTo( "#case_wrapper" );}
  end
  
  def diaries
    keywords =  params[:keywords]
    @diaries = DecorationDiary.get_diaries_for_article_tags(@city_id.to_i,RelateTag.get_diary_tag(keywords),4).
        collect{|d| {:url => d.url, :image_url => d.master_picture.url("112x80"), :title => d.title}}
    @result = {:diaries => @diaries, :city_name => @city_name}
    if params[:json]
      render :json => @result
    else
      render :text => %{$( "#diariesTemplate" ).tmpl( #{@result.to_json} ).appendTo( "#diary_wrapper" );}
    end
    
    
  end
  
  def companies
    @result = {:companies => @companies, :city_name => @city_name}
    render :text => %{$( "#companyTemplate" ).tmpl( #{@result.to_json} ).appendTo( "#company_wrapper" );}
  end

  def company_and_case
    @company_with_picture = hejia_promotion_items(54273, :attributes => ['title','url','image_url'],:limit => 1).first
    @cases =  HejiaCase.find(:all,
        :conditions => ["STATUS != '-100' and ISNEWCASE = 1 and ISZHUANGHUANG = '1' and TEMPLATE != 'room' and ISZHUANGHUANG='1' and (deco_firms.city = ? or deco_firms.district = ?) ",@city_id, @city_id],
        :joins => "join deco_firms on HEJIA_CASE.COMPANYID = deco_firms.id",
        :order => "CREATEDATE desc", :limit=>12
        ).collect{|c| {:url => c.url, :title => c.NAME.split(//)[0,12].join} }
    @events = DecoEvent.coupon_lists(@city_id,params).find(:all,:limit => 12).
              collect{|c| {:url => c.url,  :title => c.title.split(//)[0,12].join } }
    @result = {
      :company_with_picture => @company_with_picture,
      :companies => @companies,
      :cases => @cases,
      :events => @events
    }
    if params[:json]
      render :json => @result
    else
      render :text => %{$( "#companyAndCaseTemplate" ).tmpl( #{@result.to_json} ).appendTo( "#companyAndCaseTemplate_wrapper" );}
    end
  end
  
private

  def find_companies
    @companies = DecoFirm.published.by_city(@city_id).firm_list_order_for(1,@city_id).find(:all,:limit => 6).
                collect{|c| {:url => c.url, :name_zh => c.name_zh, :name_abbr => c.name_abbr, :praise => c.praise}}
  end

  def find_city_id
    @city_id, @city_name = remote_city[:number], remote_city[:name]
  end
  
  
    
end

