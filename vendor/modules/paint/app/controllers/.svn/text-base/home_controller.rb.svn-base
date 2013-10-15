class HomeController < PaintApplicationController 
  
  def index

    @adspace_page = "油漆施工-首页-顶通1"
    @paint_workers= PaintWorker.paint_top10 #油工TOP10
    @sort = ZhuanquSort.get_zhuanqu_sort "油漆工艺"
#    @diaries = HejiaIndex.diaries_by_zhuanqu_sort(@sort.id,6)
    @pictures = HejiaCase.published.NAME_like("多乐士").find(:all,:order => 'CREATEDATE desc',:limit=>10)
    #关于木器漆 和墙面漆,日记首页带图的第一篇的推广.
    # 此推广ID为推广PAINT_HOME_ARTICLE,第一条记录为木器漆,第二条为墙面漆,第三条为日记
    #木器漆和墙面漆记录中的url指端存的是他们的ID号
    @api_article = hejia_promotion_items(PAINT_HOME_ARTICLE, :attributes => ['title','entity_id','url','image_url','description'],:limit => 3)
    @paint_rating = PaintRating.find(:first)
#    @questions = AskZhidaoTopic.find(:all,:select => "id, subject",:conditions => ["interrogee = 7372654 and is_delete = 0"],:order => "id desc",:limit => 2)
#    @muqi = Article.duoleshi("木器漆",7) - Article.get_article(@api_article[0].url).to_a   #避免首页重复  改推广
#    @qiangmian = Article.duoleshi("墙面漆",7) - Article.get_article(@api_article[1].url).to_a  改推广
#    @cases = PaintCase.essence_case.find(:all, :limit => 6) 刚上线，没有数据，先用推广
	end

  # 给某品牌评价
  def paint_rating
    @paint_rating = PaintRating.find(:first)
    case params[:item]
    when "good"
      @paint_rating.good += 1
    when "soso"
      @paint_rating.soso += 1
    else
      @paint_rating.bad += 1
    end
    @paint_rating.save
    @paint_rating.reload
    render :update do |page|
      page.replace_html  'paint_rating', :partial => "paint_rating", :locals => {:paint_rating => @paint_rating}
    end
  end

  def help
    
  end
  
end
