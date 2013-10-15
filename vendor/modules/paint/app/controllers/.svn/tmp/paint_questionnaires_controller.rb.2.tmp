class PaintQuestionnairesController < PaintApplicationController
  layout "paint_questionnaires"
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token

  def get_city_json
    province_id = ActiveRecord::Base.connection.select_all("SELECT * FROM 51hejia_php.public_provinces where real_name = '#{params[:province]}'")[0]["id"]
    cities = ActiveRecord::Base.connection.select_all("SELECT * FROM 51hejia_php.public_sina_citys where provinces_id=#{province_id}").map { |c| [c["name"], c["name"]] }.compact
    render :json => cities
  end

  def new
    @paint_rating = PaintRating.find(:first)
    @paint_questionnaire = PaintQuestionnaire.new()
    @url = URI.escape("http://www.yougong.51hejia.com/paint_questionnaires/new")
    @title = URI.escape("#油漆工需求线上调查#有奖调查正在进行中，微薄分享并@三位好友就有机会获得30元电话卡！每周抽取5名幸运网友与金刷子油工一起分享快乐时光！@和家网_ @金刷子认证油工 http://www.yougong.51hejia.com/paint_questionnaires/new")
    @pic = URI.escape("http://js.51hejia.com/img/ad/ad_20121109.jpg")
  end

  def create
    @paint_questionnaire = PaintQuestionnaire.new(params[:paint_questionnaire])
    unless params[:c4].blank?
      c4 = params[:c4]
      c4.delete("")
      c4 = c4.join(";")
      c4.concat(params[:field_c4]) unless params[:field_c4].blank?
      @paint_questionnaire.c4 = c4
    end
    unless params[:c5].blank?
      c5 = params[:c5]
      c5.delete("")
      c5 = c5.join(";")
      c5.concat(params[:field_c5]) unless params[:field_c5].blank?
      @paint_questionnaire.c5 = c5
    end
    unless params[:c6].blank?
      c6 = params[:c6]
      c6.delete("")
      c6 = c6.join(";")
      c6.concat(params[:field_c6]) unless params[:field_c6].blank?
      @paint_questionnaire.c6 = c6
    end
    unless params[:c7].blank?
      c7 = params[:c7]
      c7.delete("")
      c7 = c7.join(";")
      c7.concat(params[:field_c7]) unless params[:field_c7].blank?
      @paint_questionnaire.c7 = c7
    end
    unless params[:c91].blank?
      c91 = params[:c91]
      c91.delete("")
      c91 = c91.join(";")
      c91.concat(params[:field_c91]) unless params[:field_c91].blank?
      @paint_questionnaire.c91 = c91
    end

    unless params[:c10].blank?
      c10 = params[:c10]
      c10.delete("")
      c10 = c10.join(";")
      @paint_questionnaire.c10 = c10
    end
    unless params[:c12].blank?
      c12 = params[:c12]
      c12.delete("")
      c12 = c12.join(";")
      @paint_questionnaire.c12 = c12
    end
    unless params[:c14].blank?
      c14 = params[:c14]
      c14.delete("")
      c14 = c14.join(";")
      @paint_questionnaire.c14 = c14
    end

    @paint_rating = PaintRating.find(:first)
    item = [['选 择', 'good'], ['不选择', 'soso'], ['会考虑', 'bad']].assoc(@paint_questionnaire.c15)[1]
    unless item.blank?
      case item
        when "good"
          @paint_rating.good += 1
        when "soso"
          @paint_rating.soso += 1
        else
          @paint_rating.bad += 1
      end
      @paint_rating.save
    end

    unless params[:province_city_qita].blank?
      @paint_questionnaire.province = params[:province] unless params[:province].blank?
      @paint_questionnaire.city = params[:city] unless params[:city].blank?
    end

    @paint_questionnaire.save
    render :text => "success"
  end

  def js(str, *p)
    return "<script type=\"text/javascript\">#{str.to_s}</script>"
  end

  def top_load(url)
    if url == "self"
      return "if (top!=self){ if (top.location.href.indexOf('#')==-1) top.location.href=top.location.href; else top.location.href=top.location.href.substring(0, top.location.href.indexOf('#'));}"
    elsif url == "reload"
      return "top.location.reload();"
    elsif !url.blank?
      url = '"' + url + '"'
      return "top.location.href = #{url};"
    end
  end

  def share(url, title, pic)
    string = "<a href='http://service.weibo.com/share/share.php?url=#{url.to_s}&title=#{title.to_s}&pic=#{pic.to_s}' id='weibo_share' style='display:none;' target='_blank'>微博分享</a>"
    string += "<script type='text/javascript'>"
    string += "document.getElementById('weibo_share').click();"
    string += "</script>"
    return string
  end 

end