class PicturesController < PaintApplicationController 
  
  before_filter :validate_pictures, :only => [:show]
  
  def index
    @pictures = HejiaCase.published.NAME_like("多乐士").find(:all,:order => 'CREATEDATE desc')
  end
  
  def show 
    @photos = @picture.photos
    @pictures = HejiaCase.published.NAME_like("多乐士").find(:all,:conditions =>["ID != ?", @picture.id], :order => 'CREATEDATE desc')
  end
  
  #  private ---------------------------华丽的分割线---------------------------------------
  private 
  def validate_pictures
    id = params[:id]
    @picture = HejiaCase.get_case(id)
    if @picture.nil?
      page_not_found!
    end
  end
end