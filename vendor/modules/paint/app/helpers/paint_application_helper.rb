module PaintApplicationHelper
  
  
  def page_not_found!
    render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => 404
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def description(page_description)
    content_for(:description) { page_description }
  end
  
  def keywords(page_keywords)
    content_for(:keywords) { page_keywords }
  end
  
  #多乐士文章图片链接地址
  def get_article_image_link(article)
    unless article.IMAGENAME.nil? 
      "http://radmin.51hejia.com/files/hekea/article_img/sourceImage/#{article.IMAGENAME.slice(3,8)}/#{article.IMAGENAME}"
    end
  end
  
  #多乐士文章链接地址
  def get_article_url id
    "/article/#{id}"
  end
  
  #油工页面链接地址
  def get_paint_worker_url id 
    paint_workers_path id
  end

  def generate_zt_paint_worker_url id
    paint_workers_url({:subdomain => 'www.yougong', :id => id})
  end
  
  #我的案例列表链接地址 
  def get_my_case_url(paint_worker_id, essence)
    if essence.nil?
      "/#{paint_worker_id}/cases"
    else
      "/#{paint_worker_id}/cases/essence"
    end
  end
  
  #施工工艺介绍终端页地址
  def gongyi_url id
    "/shigonggongyi/#{id}"
  end
 
  #链接到把品牌库的图库
  def get_production_url category_id
    "http://youqituliao.51hejia.com/dulux/productions/?category=#{category_id}"
  end
  
  #油工案例地址
  def get_paint_case_url case_id
    paint_case_path case_id
  end
  
  def get_paint_worker_avatar paint_worker
    unless !paint_worker.painter.nil? && !paint_worker.painter.avatar.url.nil?
      image_tag @paint_worker.painter.avatar.url 
    else
      image_tag @paint_worker.painter.avatar.url 
    end
  end

  #油工案例
  def my_cases paint_worker
    paint_worker.paint_cases.status_is(1).find(:all,:order => 'created_at desc', :limit => 3) unless paint_worker.paint_cases.nil? 
  end
  
  #油工经典案例
  def essence_case_with paint_worker
    paint_worker.paint_cases.essence_case.find(:all,:limit => 3) unless paint_worker.paint_cases.nil?
  end
 
   #案例图片的URL
   def get_img_url id
     "http://img.51hejia.com/files/hekea/case_img/tn/#{id}.jpg"
   end
 
    #首页导航变色 施工工艺
  def navigation_gongyi
    controller.controller_name == 'api_articles' && controller.action_name == 'gongyi' ? true : false
  end
   #首页导航变色 专业培训
  def navigation_peixun
    controller.controller_name == 'api_articles' && controller.action_name == 'peixun' ? true : false
  end
     #首页导航变色 一站式服务
  def navigation_fuwuzhongxin
    controller.controller_name == 'paint_contacts' ? true : false
  end
  
    #首页导航变色 在线培训申请
  def navigation_training
    controller.controller_name == 'online'&& (controller.action_name == 'training' || controller.action_name == 'training_info') ? true : false
  end
  
  #api推广图片地址
  def get_api_img_url url
    "http://d.51hejia.com/api#{url}"
  end

#油工头像地址
  def get_avatar_img avatar_file_name
    if avatar_file_name.blank?
      "http://js.51hejia.com/img/avatar_default_missing.jpg"
    else
      cloud_fs_domain('image') + avatar_file_name   
    end
  end
    #按例主图地址
  def get_case_index_img img_name
    cloud_fs_domain('image') + img_name
  end
  
  def hexie_dls(str)
    str.gsub(/多乐士/,"")
  end
  
      #首页导航变色 认证油工
  def navigation_renzheng
    controller.controller_name == 'paint_workers'&& (controller.action_name == 'renzheng' || controller.action_name == 'all') ? true : false
  end
  
  #帮助变色
  def color_member_help
    controller.controller_name == 'paint_workers' &&  controller.action_name == 'help'  ? true : false
  end
  
end
