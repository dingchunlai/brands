# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #阅读模式按钮"/#{params[:channel]}/#{params[:date]}/#{params[:id]}-#{page}"
  def read_mode_button(article_total_pages)
    url = "/#{params[:channel]}/#{params[:date]}/#{params[:id]}"
    if params[:page] == 'all'
      #如果当前是全文模式
      link_to '分页模式', url_for(:trailing_slash => url,:only_path => false, :host => request.host), :style => 'color: red', :title => "点击使用分页模式浏览文章..."
    else
      #如果当前是分页模式
      if article_total_pages > 1
        url = url_for(:trailing_slash => url+"-all", :only_path => false, :host => request.host).gsub(/\/$/,"") + "-all"
        link_to '全文模式', url, :style => 'color: red', :title => "点击使用全文模式浏览文章..."
      else
        ''
      end
    end
  end


  class HostLinkRenderer < WillPaginate::LinkRenderer
    def page_link(page, text, attributes = {})
      @template.link_to text, url_for(page).gsub(/\?page=/,"-"), attributes
    end
  end


  #jquery自动补全插件
  def include_jquery_autocomplete
    <<STR
    #{javascript_include_tag('http://js.51hejia.com/jquery/autocomplete/jquery.autocomplete.pack.js')}
    #{javascript_include_tag('http://js.51hejia.com/jquery/autocomplete/jquery.autocomplete.min.js')}
    #{stylesheet_link_tag('http://js.51hejia.com/jquery/autocomplete/jquery.autocomplete.css')}
STR
  end

  #jquery表单验证插件
  def include_jquery_easy_validator
    <<STR
    #{javascript_include_tag('http://js.51hejia.com/js/easy_validator/easy_validator.pack.js')}
    #{javascript_include_tag('http://js.51hejia.com/js/easy_validator/jquery.bgiframe.min.js')}
    #{stylesheet_link_tag('http://js.51hejia.com/js/easy_validator/validate.css?161645')}
STR
  end

  def afp_code
    <<START
    <script type="text/javascript">//<![CDATA[
    ac_as_id = 51981;
    ac_format = 0;
    ac_mode = 1;
    ac_group_id = 1;
    ac_server_base_url = "afp.csbew.com/";
    //]]></script>
    <script type="text/javascript" src="http://static.csbew.com/k.js"></script>
START
  end

  def render_ad(id, remark="", type="afp")
    remark = "#{type}广告代码　" + remark + "　"
    if type=="afp"
      <<START

      <!-- #{remark + "START　" + "="*30} -->
      <script type="text/javascript">//<![CDATA[
      ac_as_id = #{id};
      ac_format = 0;
      ac_mode = 1;
      ac_group_id = 1;
      ac_server_base_url = "afp.csbew.com/";
      //]]></script>
      <script type="text/javascript" src="http://static.csbew.com/k.js"></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    elsif type=="openx"
      <<START

      <!-- #{remark + "START　" + "="*30} -->
      <script type='text/javascript'><!--//<![CDATA[
      var m3_u = (location.protocol=='https:'?'https://a.51hejia.com/www/delivery/ajs.php':'http://a.51hejia.com/www/delivery/ajs.php');
      var m3_r = Math.floor(Math.random()*99999999999);
      if (!document.MAX_used) document.MAX_used = ',';
      document.write ("<scr"+"ipt type='text/javascript' src='"+m3_u);
      document.write ("?zoneid=#{id}");
      document.write ('&amp;cb=' + m3_r);
      if (document.MAX_used != ',') document.write ("&amp;exclude=" + document.MAX_used);
      document.write (document.charset ? '&amp;charset='+document.charset : (document.characterSet ? '&amp;charset='+document.characterSet : ''));
      document.write ("&amp;loc=" + escape(window.location));
      if (document.referrer) document.write ("&amp;referer=" + escape(document.referrer));
      if (document.context) document.write ("&context=" + escape(document.context));
      if (document.mmm_fo) document.write ("&amp;mmm_fo=1");
      document.write ("'><\/scr"+"ipt>");
      //]]>--></script>
      <!-- #{remark + "END　" + "="*32} -->
START
    end
  end

  def render_subnav
    # 如果模板有对应的subnav partial页面，就渲染该partial；否则什么都不做。
    file = Rails.root.join('app/views', controller.class.controller_path, "_subnav.html.erb")
    if file.file?
      content_tag(:nav, :class => 'subnav') {
        render :partial => File.join(controller.class.controller_path, "subnav")
      }
    end
  end

  # 显示flash中的信息
  def show_flash_message
    msg, css_class =
      if flash[:notice]
      [flash[:notice], 'notice']
    elsif flash[:alert]
      [flash[:alert], 'alert']
    end
    if msg
      content_tag :p, msg, :class => css_class
    end
  end
  


  # 根据参数，设置页面上的元数据（title, keywords, and description）
  # @example
  #   set_page_meta_data '首页'
  #   set_page_meta_data '品牌', '厨房电器', '方太'
  def set_page_meta_data(*args)
    values = args.last.is_a?(Hash) ? args.pop : nil
    data = args.inject(Hejia::Brands::HTML_META) { |container, key| container[key] }
    set_page_title(data && Brands::Interpolater.interpolate(data['title'], values))
    set_page_meta_keywords(data && Brands::Interpolater.interpolate(data['keywords'], values))
    set_page_meta_desc(data && Brands::Interpolater.interpolate(data['description'], values))
  end

  # 设置页面的标题
  def set_page_title(title)
    @page_title = title
  end

  # 设置页面的关键字元数据
  def set_page_meta_keywords(keywords)
    @page_meta_keywords = keywords
  end

  # 设置页面的描述字元数据
  def set_page_meta_desc(desc)
    @page_meta_desc = desc
  end
  
  #api推广图片地址
  def api_img_url_for image_url
    "http://img.51hejia.com/api#{image_url}"
  end
  
  # 返回格式化的通过api读取出来的数据的发布日期
  def publish_date_of(api_item)
    if api_item.respond_to?(:[]) && (time = api_item['entity_created_at'] || api_item['publish_time'])
      case time
      when Time, Date, DateTime
        time
      else
        Date.parse(time.to_s)
      end.strftime('%Y-%m-%d')
    else
      ''
    end
  end

  # 文章终端页地址
  def show_article_link(article, options={})
    text = article.title
    text = truncate text, :length => options[:truncate], :omission => '' if options[:truncate]
    text = "<strong>#{text}</strong>" if options[:strong]

    url =
      if article.respond_to?(:url) || article.respond_to?(:[]) && article['url']
      article.url
    else
      generate_article_url(article, {:tag => options[:tag]})
    end
    link_to text, url, :target => '_blank', :title => article.title
  end
  
  # 生成文章地址
  def generate_article_url(article, options={})
    (LINK_URLS[options[:tag].TAGNAME]['文章地址']).to_s + "#{article.CREATETIME.strftime('%Y%m%d')}/#{article.id}" unless LINK_URLS[options[:tag].TAGNAME].blank?
  end

  
  #得到其他品牌
  def get_anther_brand(brand_category_id,brand)
    Brand.of_tag(brand_category_id) - [brand]
  end

  ## b.51hejia.com中的点评
  def youhui_remarks
    key = "youhui_remarks"
    Hejia[:cache].fetch(key, 6.hours) do
      Coupon.find_by_sql("SELECT f.id,f.brand_id,f.city_id,ff.nums,ff.newsrid,ff.resource_id FROM product.coupons f LEFT JOIN (SELECT MAX(id) AS newsrid,resource_id, COUNT(resource_id) AS nums FROM `51hejia`.`remarks` GROUP BY resource_id) ff ON f.id=ff.resource_id ORDER BY ff.nums DESC LIMIT 4")
    end
  end

  # 删去所有html标签，并删去所有html的特殊字符（&ndsp;之类的），然后把剩下的字符串按要求截取
  # @param [String] text 要截取的字符串
  # @param [Integer] length 保留的字符数
  # @param [String] omission 代替被截去的字符的文本
  # @return [String] 截取后的字符串
  def truncate_u(text, length = 20, omission = "")
    truncate text.to_s.gsub(/<\/?[^>]*>/, "").gsub(/&\w+;/, ''), :length => length, :omission => omission
  end

  # 生成带有title的连接，并带有截字功能。
  # 这个方法与link_to方法的使用一致，可参考：
  # http://api.rubyonrails.org/classes/ActionView/Helpers/UrlHelper.html#M001597
  # 区别是：
  # * 自动加上连接的title属性；
  # * 加了一个:truncate的参数，接受一个整数，调用trucate_u方法来截取字符。
  def link_to_with_title(*args, &block)
    text, options, html_options =
      if block_given?
      [capture(&block), args.first || {}, args.second || {}]
    else
      [args.first, args.second || {}, args.third || {}]
    end
    html_options[:title] = text unless html_options.key?(:title)
    if limit = html_options.delete(:truncate)
      text = truncate_u text, limit
    end
    link_to text, options, html_options
  end

  # 在原有的功能上加上：默认第二天的零点过时
  def customized_cache(name={}, options=nil, &block)
    expires_at = Time.now + 1.day
    expires_at = Time.local expires_at.year, expires_at.month, expires_at.day
    options = {:expires_in => (expires_at - Time.now).round}.merge(options || {})
    cache name, options, &block
  end

  # 广告代码
  # @override
  #   advertisement_code(id, type)
  #   @param [Integer] id 广告代码的id
  #   @param [Symbol] type 广告代码的种类，:openx或:afp
  # @override
  #   advertisement_code(options)
  #   @param [Hash] options
  #   @option [Integer] :id 广告代码的id
  #   @option [Symbol, String] :type 广告代码的种类，:openx或:afp
  def advertisement_code(*args)
    id, type =
      if args.first.kind_of?(Hash)
      args.first.values_at :id, :type
    else
      args
    end
    render :partial => "shared/#{type}_advertisement_code", :locals => {:id => id}
  end

  #辅助will_paginate插件显示记录数的方法
  def mypage_entries_info(rs, options={})
    options[:show_total_entries] = true if options[:show_total_entries].nil?
    options[:show_page_link] = false if options[:show_page_link].nil?
    options[:entry_name] = "记录" if options[:entry_name].nil?
    total_page = (rs.total_entries.to_f/rs.per_page.to_f).ceil
    strs = []
    strs << "总共<b>#{rs.total_entries}</b>条#{options[:entry_name]}" if options[:show_total_entries]
    strs << "当前显示第<b>#{rs.current_page}</b>页 共<b>#{total_page}</b>页"
    strs << will_paginate(rs,:inner_window => 1,:outer_window => 1,:page_links => false,:prev_label => '上一页',:next_label => '下一页') if options[:show_page_link]
    return strs.join(" 　")
  end

  #截取含中文的字符串部分内容
  def ul(str, len, preview=0, replacer="...", do_strip_tags=1)
    if preview == 1
      str = "预览内容" * 80
    end
    str = strip_tags(str.to_s.gsub("&nbsp;", " ").gsub("\r\n", "")) if do_strip_tags==1
    if str.length > 0
      s = str.split(//u)
      if s.length > len.to_i && len.to_i != 0
        return s[0, len.to_i].to_s + replacer
      else
        return str
      end
    else
      return ""
    end
  end

  #装修公司二级导航
  def firm_sub_link firm, text, path, count, hightlight_text
    if count > 0
      content_tag(:li, link_to("#{text}(#{count})", path, :target=>"_self"),:class=> (hightlight_text == controller.controller_name ? "current" : ""))
    elsif count < 0
      content_tag(:li, link_to("#{text}", path, :target=>"_self"),:class=> (hightlight_text == controller.controller_name ? "current" : ""))
    end
  end

  #装修公司一级导航
  def firm_sub_1_link text, path, hightlight_text
    if controller.controller_name == "top"
      content_tag(:li, link_to("#{text}", path, :target=>"_self"),:class=> (hightlight_text == controller.controller_name ? "hack active" : ""))
    elsif hightlight_text == "top" && controller.controller_name != 'top'
      content_tag(:li, link_to("#{text}", path, :target=>"_self"),:class=> "hack")
    else
      content_tag(:li, link_to("#{text}", path, :target=>"_self"),:class=> (hightlight_text == controller.controller_name ? "active" : ""))
    end
  end
   
  # 新推广位获取方法
  def promotion_items code
    PromotionCollection.published_items_for code
  end

  alias :new_promotion_items :promotion_items

  # 根据当前推广页面，品牌，品类， 推广名称 生成具体的code
  # 此方法将是promotion_items的替代品
  def find_promotion_item(promotion_page, object_tag, object_brand, item_name)
    promotion_items promotion_page.item_code(promotion_page.name, object_tag.TAGURL, object_brand.permalink, item_name)
  end

  def text_to_html(str)
    str = str.to_s
    unless str.blank?
      str = strip_tags(str)
      str = str.gsub(" ", "&nbsp;")
      str = str.gsub("\n", "<br />")
      #str = str.gsub("[img]", "<img src='")
      #str = str.gsub("[/img]", "' onload='if (this.width>690) this.width=690;' />")
    end
    return str
  end

  # 我们专门在jsN.51hejia.com下创建了一个存放jquery相关的资源。
  # 这个helper就是方便的获取这些资源。
  def jquery_resource(options = nil)
    version = options[:version]
    if plugin = options[:plugin]
      resource = case options[:resource]
      when NilClass, :js, 'js'
        "jquery.#{plugin}.min.js"
      when :css, 'css'
        "jquery.#{plugin}.css"
      else
        options[:resource]
      end
      "http://#{JS_DOMAINS.rand}/js/jquery/plugins/#{plugin}/#{version}/#{resource}"
    else
      "http://#{JS_DOMAINS.rand}/js/jquery/#{version}/jquery.min.js"
    end
  end
  
  #自动的stylesheet
  #开发环境和线下测试都直接读public/javascripts,线上测试和生产环境读js.51hejia.com
  def stylesheet(*args)
    if RAILS_ENV == "development" || RAILS_ENV == "staging"
      content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
      # elsif RAILS_ENV == "rehearsal"
      #   content_for(:head) { stylesheet_link_tag(*args.map{|s| "http://js.51hejia.com/css/brands/rehearsal/" + s.to_s  + "?" + TIMESTAMPS })}
    else
      content_for(:head) { stylesheet_link_tag(*args.map{|s| s.to_s  + "?" + TIMESTAMPS })}
    end
  end
  
  def javascript(*args)
    if RAILS_ENV == "development" || RAILS_ENV == "staging"
      content_for(:head) { javascript_include_tag(*args) }
      # elsif RAILS_ENV == "rehearsal"
      #   content_for(:head) { javascript_include_tag(*args.map{|s| "http://js.51hejia.com/js/brands/rehearsal/" + s.to_s + "?" + TIMESTAMPS }) }
    else
      content_for(:head) { javascript_include_tag(*args.map{|s| s.to_s + "?" + TIMESTAMPS }) }
    end
  end
  
  def css_url(*args)
    if RAILS_ENV == "development" || RAILS_ENV == "staging" || RAILS_ENV == "rehearsal"
      content_for(:head) { stylesheet_link_tag(*args.map{|s| "http://js.51hejia.com/css/rehearsal/" + s.to_s  + "?" + TIMESTAMPS })}
    else
      content_for(:head) { stylesheet_link_tag(*args.map{|s| "http://js.51hejia.com/css/" + s.to_s  + "?" + TIMESTAMPS })}
    end
  end
  
  def dp_js(*args)
    if RAILS_ENV == "development"
      content_for(:head) { javascript_include_tag(*args) }
    elsif RAILS_ENV == "staging"
      content_for(:head) { javascript_include_tag(*args.map{|s| "/javascripts/" + s.to_s + "?" + TIMESTAMP }) }
    elsif RAILS_ENV == "rehearsal"
      content_for(:head) { javascript_include_tag(*args.map{|s| "http://js.51hejia.com/js/dianping/rehearsal/" + s.to_s + "?" + TIMESTAMP }) }
    else
      content_for(:head) { javascript_include_tag(*args.map{|s| "http://js.51hejia.com/js/dianping/" + s.to_s + "?" + TIMESTAMP }) }
    end
  end

  def dp_css(*args)
    if RAILS_ENV == "development" || RAILS_ENV == "staging"
      content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
    else
      # TODO
      #  *args.map{|s| s = s + ".css" if s[-4..-1] != ".css" }
      content_for(:head) { stylesheet_link_tag(*args.map{|s| "http://js.51hejia.com/css/dianping/" + s.to_s  + "?" + TIMESTAMP }) }
    end
  end
   
   
  
  # 得到品牌页面html_metadata
  def set_brand_page_meta_data(tag_name, brand_permalink)
    html = HtmlMetadata.find_by_url show_pinpai_url(brand_permalink, :subdomain => tag_name)
    unless html.blank?
      set_page_title(html.title)
      set_page_meta_keywords(html.keywords)
      set_page_meta_desc(html.description)
    end
  end

  # 得到品牌页面html_metadata
  def set_page_meta_data_for_page_id(page_id)
    html = HtmlMetadata.find_by_page_id page_id 
    unless html.blank?
      set_page_title(html.title)
      set_page_meta_keywords(html.keywords)
      set_page_meta_desc(html.description)
    end
  end


  #老日记URL 方法
  def diary_url(diary)
    decoration_diary_url(:id => diary.id)
  end
  

  
  #根据公司得到点评的前URL
  def firm_absolute_path(firm)
    if firm.city.to_i == 11910
      "http://z.shanghai.51hejia.com"
    elsif firm.city.to_i == 11905
      "http://z.beijing.51hejia.com"
    elsif firm.city.to_i == 31959
      "http://z.guangzhou.51hejia.com"
    else
      "http://z.#{TAGURLS[firm.district.to_i]}.51hejia.com"
    end
  end
  

  
  #公司按类别搜索地址
  #注意,如果传condition参数不用传/price/style/price/district/参数
  def search_firm_for_options(options = nil)
    condition = options[:condition]
    price = options[:price].to_i
    order =  options[:order].to_i
    style = options[:style].to_i
    district =  options[:district].to_i
    model = options[:model].to_i
    if condition.blank?
      condition = "#{model}#{style}#{price}#{district}"
    end
    firms_order_url(:order => order,:condition => condition,:trailing_slash => "/")
  end
  
  #日记按类别搜索地址
  def search_diaries_for_options(options = nil)
    condition = options[:condition]
    price = options[:price].to_i
    order =  options[:order].to_i
    style = options[:style].to_i
    model = options[:model].to_i
    room = options[:room].to_i
    if condition.blank?
      condition = "#{model}#{style}#{price}#{room}"
    end
    decoration_diaries_order_url(:order => order,:condition => condition,:trailing_slash => "/")
  end
  #案例按类别搜索地址/zhuangxiuanli-:price-:style-:model:-:use-:room-:page
  
  def search_cases_for_options(options = nil)
    condition = options[:condition]
    price = options[:price].to_i
    style = options[:style].to_i
    model = options[:model].to_i
    room = options[:room].to_i
    if condition.blank?
      condition = "#{model}#{style}#{price}#{room}"
    end
    cases_order_page_url(:condition => condition,:page => 1,:trailing_slash => "/")
  end
  
  #给文字加上样式
  def get_text_style(title, style_key)
    style_key = 0 if style_key.nil?
    style = PublishTextStyle.get_value(style_key).find(:first)
    style.style_value.gsub("@title", title)
  end

  # PV，可以是日记的也可以是别的
  def increase_pv_image_tag class_name, id
    image_tag "/stat/#{class_name}/#{id}.gif?#{Time.now.to_i}", :style => 'display: none;'
  end

  def increase_haier_pv_image_tag class_name, id
    image_tag "http://z.shanghai.51hejia.com/stat/#{class_name}/#{id}.gif?#{Time.now.to_i}", :style => 'display: none;'
  end

  # strip_html_except options(tags, include)
  # options[:tags] html_tags
  # options[:include] inclde_except_html_tags (true or false) include is true ,except is false
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

  #解析api对应栏目的xml输出
  def parse_api_xml(xml, parameters)
    column_id = xml.to_s.gsub("http://api.51hejia.com/rest/build/xml/", "").gsub(".xml", "")
    Hejia[:cache].fetch("api_xml_parse_#{column_id}", 1.day ) do
      xml_doc = Nokogiri::XML(open("#{xml}?#{rand(9999)}").read)
      nodes   = xml_doc.xpath("//publish_content").collect do |node|
        item = node.children.inject({}) do |one, child|
          if parameters.index(child.name)
            if child.name == "image-url"
              one[child.name] = ((child.text =~ /\Ahttp/) ? child.text : ("http://img.51hejia.com/api" + child.text)) unless child.text.nil?
            else
              one[child.name] = child.text
            end
          end
          one
        end
        item
      end
      nodes
    end
  end
 
end
