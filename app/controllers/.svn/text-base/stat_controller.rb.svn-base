class StatController < ApplicationController

  before_filter ReferrerFilter.hejia_referrer
  before_filter BrandValidationFilter, :only => :brands

  #品牌页访问数(关注度)执行递增操作
  def brands
    @brand.increase_pv! @tag.TAGID
  rescue
    logger.error "ERROR | StatController#brands | #$!"
    logger.error $@.join("\n")
  ensure
    send_empty_gif
  end
  
  def decoration_diary
    begin
      DecorationDiary.find(params[:id]).increase_pv!
    rescue 
      logger.error "ERROR | StatController#decoraton_diary | #$!"
    ensure
      send_empty_gif
    end
  end

  def deco_firm   
    begin
      DecoFirm.find(params[:id]).increase_pv!
    rescue 
      logger.error "ERROR | StatController#deco_firm | #$!"
    ensure
      send_empty_gif
    end
  end
  
  def deco_idea
    begin
      DecoIdea.find(params[:id]).increase_pv!
    rescue
      logger.error "ERROR | StatController#deco_idea | #$!"
    ensure
      send_empty_gif
    end
  end

  def deco_service
    begin
      DecoService.find(params[:id]).increase_pv!
    rescue
      logger.error "ERROR | StatController#deco_service | #$!"
    ensure
      send_empty_gif
    end
  end

  def hejia_case
    begin
      HejiaCase.find(params[:id]).increase_pv!
    rescue
      logger.error "ERROR | StatController#hejia_case | #$!"
    ensure
      send_empty_gif
    end
  end
  

  def send_empty_gif
    headers['Cache-Control'] = 'no-cache'
    headers['Pragma'] = 'no-cache'
    send_file File.join(RAILS_ROOT, 'public/empty.gif'), :type => 'image/gif', :disposition => 'inline', :filename => 'stat.gif'
  end
  private :send_empty_gif

end

#------
