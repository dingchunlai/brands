module Dianping::ApplicationHelper
    
  # 高亮二级导航栏当前页面
  def highlight controller_name
    "current" if controller.controller_name == controller_name
  end
  
  # 设计师头像
  def designer_avatar designer
    image_tag "http://d.51hejia.com/files/designer/#{designer.PICURL}", :alt => truncate_u(designer.DESNAME,8)
  end


  #日记api推广图
  def get_api_img_url url
    "http://d.51hejia.com/api#{url}"
  end

  # 根据城市和标签得到城市标签对应的价格
  def diff_city_price_tag_value(city, key)
    price_name = ""
    if city.to_i == 12301
      price = NINBO_PRICE
      price.select{|k, v| price_name = v if k == key.to_i}
    else
      price = PRICE
      price_name = price[key.to_i]
    end
    price_name
  end
  
  # diff_city_generate_diff_price
  def diff_city_price_tag city
    price = [12117, 12301].include?(city.to_i) ? NINBO_PRICE.sort : PRICE.sort
  end

  
  #生成公司地址的老方法.不改方法名了.
  def generate_firm_path firm
    Hejia[:cache].fetch("appliaction/generate_firm_path/#{firm}", 1.hour) do
      firm = firm.is_a?(DecoFirm) ? firm : DecoFirm.find(firm)
      city = (firm.city == 11910 || firm.city == 11905 || firm.city == 31959) ? firm.city.to_i : firm.district.to_i
      city_name = TAGURLS[city]
      firm_url(:id => firm.id,:trailing_slash => "/")
    end
  end
  
  def search_room_url(city_code, room ,controller_name)
    if controller_name == "decoration_diaries"
      search_diaries_for_options(:room => DecoFirm::ROOM.index(room))
    elsif controller_name == "cases"
      search_cases_for_options(:room => DecoFirm::ROOM.index(room) )
    else
      if room == "别墅"
        villa_url(:trailing_slash => "/")
      else
        price = [12117, 12301].include?(city_code.to_i) ?  DecoFirm::NINBO_PRICE.index(DecoFirm::PRICE_FOR_ROOM_NINBO[room]) : DecoFirm::PRICE.index(DecoFirm::PRICE_FOR_ROOM[room])
        search_firm_for_options(:price => price )
      end
    end
  end

  #生成公司地址
  def gen_firm_city_path(firm_id)
    #    return "/firms-#{firm_id}"
    key = "zhaozhuangxiu_firm_path_#{firm_id}_5_#{Time.now.strftime('%Y%m%d%H')}"
    if Hejia[:cache].get(key).nil?
      firm = DecoFirm.getfirm(firm_id)
      if firm.city.to_i == 11910
        result = get_domain(11910)
      elsif firm.city.to_i = 11905
        result = get_domain(11905)
      elsif firm.city.to_i = 31959
        result = get_domain(31959)
      else
        result = get_domain(firm.district)
      end
      result = result + "/#{firm.id}/"
      Hejia[:cache].set(key,result)
    else
      result = Hejia[:cache].get(key)
    end
    return result
  end

  def get_domain(city_id)
    if IS_PRODUCT.to_i == 1
      if city_id.to_i == 11910
        return 'http://z.shanghai.51hejia.com'
      elsif city_id.to_i == 12117
        return 'http://z.suzhou.51hejia.com'
      elsif city_id.to_i == 12122
        return 'http://z.nanjing.51hejia.com'
      elsif city_id.to_i == 12301
        return 'http://z.ningbo.51hejia.com'
      elsif city_id.to_i == 12306
        return 'http://z.hangzhou.51hejia.com'
      elsif city_id.to_i == 12118
        return 'http://z.wuxi.51hejia.com'
      elsif city_id.to_i == 12093
        return 'http://z.wuhan.51hejia.com'
      elsif city_id.to_i == 12122
        return 'http://z.nanjing.51hejia.com'
      elsif city_id.to_i == 12173
        return 'http://z.qingdao.51hejia.com'
      elsif city_id.to_i == 12109
        return 'http://z.changsha.51hejia.com'
      elsif city_id.to_i == 11921
        return 'http://z.hefei.51hejia.com'
      elsif city_id.to_i == 12059
        return 'http://z.zhengzhou.51hejia.com'
      elsif city_id.to_i == 11905
        return 'http://z.beijing.51hejia.com'
      elsif city_id.to_i == 31959
        return 'http://z.guangzhou.51hejia.com'
      elsif city_id.to_i == 11971
        return 'http://z.shenzhen.51hejia.com'
      elsif city_id.to_i == 12013
        return 'http://z.haikou.51hejia.com'
      elsif city_id.to_i == 11944
        return 'http://z.xiamen.51hejia.com'
      elsif city_id.to_i == 12243
        return 'http://z.chengdu.51hejia.com'
      else
        return 'http://z.51hejia.com'

      end
    else
      return ''
    end
  end

  def location location_text = ""
    content_for (:location) do
      location_text
    end
  end
  
  def firm_sub_menu( location_text = "")
    content_for (:firm_sub_menu) do
      render :partial => '/dianping/shared/firm_sub_menu'
    end
  end
  

  def whitelist_strip_tags(html, options = {})
    return html if html.blank?
    if html.index('<')
      text = ""
      whitelist = options[:tags] || []
      tokenizer = HTML::Tokenizer.new(html)
      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        text << node.to_s if HTML::Text === node || (options[:include] ? whitelist.include?(node.name) : !whitelist.include?(node.name))
      end
      text.gsub(/<!--(.*?)-->[\n]?/m, '')
    else
      html
    end
  end

  # 移除页面上外部链接
  def remove_external_links text
    text.gsub!(%r'(https?://|www\.)[[:graph:]]+') { |a| a =~ %r'http://([^/])*\.51hejia\.com' ? a : '' }
    text
  end

  #后台发表日记,插入表情时,IE浏览器不会自动加入域名,这个应该在存进数据时就修改掉.
  def add_domain_for_diary text
    text.gsub!(%r'src="/javascripts/plugins/kindeditor/plugins/emoticons/','src="http://member.51hejia.com/javascripts/plugins/kindeditor/plugins/emoticons/')
    text
  end
  
  def formated_info label, value, att, text="", url=""
    
    value_name = url.blank? ? value[att] : link_to(value[att], url, :target =>"_blank")
    value_name = truncate(value_name, :length => 11 ,:omission => '') if label == "楼盘信息："
    %{
      <tr>
        <td width="60"><span>#{label}</span></td>
        <td>#{value_name} #{text}</td>
      </tr>
    } 
  rescue
    nil
  end

  #日记显示真精结图标
  def show_icon_diary diary,city
    image_data = []
    unless [11910,12301,12117,12306,12118].include? city.to_i
      image_data << image_tag('http://js.51hejia.com/img/zxdpimg/zhen.gif') if diary.is_verified.to_i == 1
    end
    image_data << image_tag('http://js.51hejia.com/img/zxdpimg/zxdp2011_rjicon2.gif') if diary.is_good.to_i == 1
    unless (city.to_i == 11910 || city.to_i == 11905 || city.to_i == 31959) && controller.controller_name == 'decoration_diaries' && controller.action_name == 'index'
      image_data << image_tag('http://js.51hejia.com/img/zxdpimg/jie.gif') if diary.finished?
    end
    image_data.join(' ')
  end

  #是否合作公司
  def firm_is_cooperation? firm
     firm.is_cooperation.to_i == 1
  end
  
  # 因为用了原来的头,所以临时加上这些方法,后面会和谐掉
  #get hejia_bbs_user_export_counts
  def has_many_hejia_bbs_user_export_number
    Hejia[:cache].fetch "export_number", 1.day do
      HejiaUserBbs.count(:all, :conditions => ["USERTYPE = 100"])
    end
  end

  # get decoration_diaries_counts
  def has_many_decoration_diaries_number
    Hejia[:cache].fetch "decoration_diaries_number", 1.day do
      DecorationDiary.has_many_decoration_diaries_number
    end
  end

  # get remark_counts
  def has_many_net_friend_remarks_number
    Hejia[:cache].fetch "net_friend_remarks_number", 1.day do
      Remark.net_friend_remarks_number
    end
  end

  # get deco_firm_counts
  def has_many_deco_firm_number
    Hejia[:cache].fetch "deco_firm_number", 1.day do
      DecoFirm.has_many_deco_firm_number
    end
  end

  def city_qq_chat(city_code)
    case city_code
    when 12117 ; "QQ:1466079700"
    when 12301 ; "QQ:27327132"
    when 12306 ; "QQ:1025439731"
    when 12118 ; "QQ:62751543"
    when 11910 ; "QQ:471953858，1293214783"
    end
  end
  
  def remark_username user
    url = if user.deco_firm && !user.deco_firm.supervisor_url.blank?
      user.deco_firm.supervisor_url
    else
      ""
    end

    icon = image_tag("http://js.51hejia.com/img/icon_jian.gif",:style=>"vertical-align: middle;") if user && user.class_name=="Supervisor"
    if url.blank?
      %{#{ user.USERNAME}#{icon}}
    else
      %{#{ link_to user.USERNAME, url, :style=> "color:#FF6600;", :target=>'_blank'} #{link_to icon, url, :target=>'_blank'}}
    end
  end

  #装修公司右边top10标题
  def assort_title(model,style,price,city_code)
    if model.to_i != 0
      DecoFirm::MODELS[model.to_i]
    elsif style.to_i != 0
      DecoFirm::STYLES[style.to_i]
    elsif price.to_i != 0
      [12117].include?(city_code.to_i) ? DecoFirm::NINBO_PRICE[price.to_i] : DecoFirm::PRICE[price.to_i]
    else
      "装修公司"
    end
  end

  # 按城市提取 排名
  def assort_firms(city, limit = 10)
    Hejia[:cache].fetch "dianping:firms:assort_firms:#{city}:#{limit}", 5.minutes do
      DecoFirm.by_city(city).firms_by_cooperation_praise_for([], limit)
    end
  end

  # 提取某公司的印象数据
  def deco_firm_impressions(firm_id, limit)
    DecoImpression.charts(firm_id, 12)
  end

  def photo_zone_tags(photos, id)
    PhotoPhotosTag
    key = "key_photo_show_photos_tag_new_#{id}"
    if Hejia[:cache].get(key) && Hejia[:cache].get(key).any?
      tags = Hejia[:cache].get(key)
      tags
    else
      if photos && photos.any?
        sql = "SELECT ppt.tag_id as id, count(ppt.photo_id) as photo_count, pt.name as name FROM photo_photos_tags ppt" +
          " LEFT JOIN photo_tags pt ON (ppt.tag_id = pt.id) where ppt.photo_id in (#{photos.map { |photo| photo.id }.join(",")}) and ppt.type_id = 1 group by ppt.tag_id"
        tags = PhotoPhotosTag.find_by_sql(sql)
        Hejia[:cache].set(key, tags)
        tags
      end
    end
  end

  def get_remark_editor(remark)
    if remark.hejia_bbs_user
      if remark.hejia_bbs_user.deco_id == 0
        remark.hejia_bbs_user
      else
        DecoFirm.find(remark.hejia_bbs_user.deco_id)
      end
    end
  end
  
  # 从firm_helper移到app
  def firm_address firm
    firm.address2.blank? ? ['暂无信息'] : firm.address2.split(/,|，/).map{|address_1| address_1 }
  end

  #
  def firm_telphone firm
    firm.telephone.strip.blank? ? ['暂无联系电话'] : firm.telephone.strip.split(/,|，/).map{|tel| tel }
  end

  def firm_tel firm
    if firm.district == 12301 && firm.is_cooperation != 1
      ["0574-27673566"]
    elsif firm.district == 12118 && firm.is_cooperation != 1
      ["0510-82700070"]
    elsif firm.district == 12306 && firm.is_cooperation != 1
      ["0571-88831082"]
    elsif firm.district == 12093 && firm.is_cooperation != 1
      ["027-85515347/85714739"]
    elsif firm.telephone.blank?
      ["该商家未提供客服电话"]
    else
      firm.telephone.split(/,|，/).map{|tel| tel }
    end
  end

  # 根据公司查询出来对应的抵用劵信息
  def fetch_firm_coupon firm_id
    Coupon
    Hejia[:cache].fetch "dianping:firm:#{firm_id}:distributor:coupon:first", 5.minutes do
      distributor_deco_firm = DistributorDecofirm.find_by_deco_firm_id(firm_id, :include => {:distributor => :coupons})
      unless distributor_deco_firm.blank?
        coupon = distributor_deco_firm.distributor.coupons.valid.last
        coupon.blank? ? nil : coupon 
      else
        nil
      end
    end
  end

  # 公司测房预约排行榜
  def applicant_top_firm(city_code, limit=10)
    Applicant
    DecoFirm
    Hejia[:cache].fetch "dianping:applicant_top:#{city_code}:#{limit}:common", 5.minutes do
      Applicant.applicat_top(limit).for_city(city_code)
    end
  end

  #预约参观在建样板房
  def promoted_factories_right(city_code)
    CaseFactoryCompany
    factories = []
    Hejia[:cache].fetch "dianping:factories_top:#{city_code}:right", 5.minutes do
      hejia_promotion_items(NEW_DIANPING_HOME_API[TAGURLS[@user_city_code.to_i]]['在建工地'], :attributes => ['title','url','image_url'],:limit => 10).each do |c|
        factory = CaseFactoryCompany.find_by_ID(c.title.to_i, :include => [:deco_firm])
        factories << factory unless factory.blank?
      end
      factories
    end
  end

  #优惠券2套地址

  def two_coupon_urls(city,event)
    if NEW_ONLINE_CITY.include? city.to_i
      new_coupon_path(:firmid =>event.firms[0].id,:id =>event)
    else
      coupon_path(:id =>event)
    end
  end
 
end
