# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'socket'

class ApplicationController < ActionController::Base

  include ::RailsResourceMonit::MemoryUsageLogger
  helper RelateTagsHelper
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  prepend_before_filter :set_server_hostname_header

  before_filter :get_promotion_items_for_layout
  before_filter :set_current_user

  before_filter  :preload_models

  def preload_models()
    Coupon
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    session[:last_request_uri] = request.request_uri
    redirect_to '/admin_v2'
  end

  protected

  def page_not_found!
    render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => 404
  end
  
  def redirect_301_to url
    headers["Status"] = "301 Moved Permanently"
    redirect_to url
  end
  
  def authenticate
    unless staff_logged_in?
      authenticate_or_request_with_http_basic do |u, pw|
        staff = RadminUser.find :first, :select=>"id, pw_md5, role, idate",
          :conditions=>["name = ?", u]
        if staff.nil?
          err_info = "用户名不存在"
        elsif staff.pw_md5 != Digest::MD5.hexdigest(pw)
          err_info = "密码错误"
        elsif staff.idate < Time.now
          err_info = "用户账号已失效"
        else
          login_staff! staff
          roles = staff.role.to_s.split(",").map! &:to_i
          if roles.include?(115) || roles.include?(143)
            err_info = ""
            session[:is_hejia_admin] = roles.include?(115)
          else
            err_info = "角色无此权限"
          end
        end
        err_info.blank?
      end
    end

    staff_logged_in?
  end

  def page
    params[:page].to_i > 0 ? params[:page].to_i : 1
  end
  helper_method :page

  # 获得shared/layouts/_header.html.erb所需要的推广记录。
  def get_promotion_items_for_layout
    @promotion_items = inject_promotion_items '首页',
      ['页头广告', {:limit => 1, :include => ['image_url']}],
      ['热门搜索', {:limit => 5}]
  end

  # 获得指定的推广记录。
  # 方法签名：
  # inject_promotion_items [container], [type1], [type2], ..., [typeN], item1, [item2], ..., [itemN]
  # @param [Hash] container 可选。所得记录存储的容器，不指定则使用一个新的Hash。
  # @param [String, ...] type 可选，可多个。推广所属的类别。
  # @param [Array, ...] item 可选，可多个。推广的项目，包括两个元素，id和属性（Hash）。
  # 
  # @example
  # get_promotion_items_for_layout的源代码可作为参考。
  def inject_promotion_items(*args)
    result = container = args.first.is_a?(Hash) ? args.shift : {}

    promotion_mapping = API_PROMOTION_MAPPING
    while args.first.is_a?(String)
      prefix = args.shift
      promotion_mapping = promotion_mapping[prefix]
      container = (container[prefix] ||= {})
    end

    args.inject(container) { |items, (item, options)|
      options ||= {}
      items[item] = hejia_promotion_items promotion_mapping[item], options
      items[item] = items[item].first if options.key?(:limit) && options[:limit] == 1
      items
    }

    result
  end

  # 求得推广记录的最后修改时间。
  # @param [Hash] items inject_promotion_items返回的结果
  # @return [ActiveSupport::TimeWithTimeZone] 最后修改时间
  def last_modified_of_promotion_items(items)
    (items = items.deep_values).flatten!
    items.uniq!
    items.map! { |item|
      if item.publish_time.is_a?(String)
        Time.zone.parse item.publish_time
      else
        item.publish_time
      end
    }.sort!.last.utc
  end

  def set_current_user
    Thread.current[:current_user] = current_user
  end

  # 因为我们有多种用户，所以需要重写一下cacan的方法。
  def current_ability
    @current_ability ||= ::Ability.new(current_user || current_staff)
  end

  def current_ability_user
    @current_ability_user ||=
      begin
      users = []
      users << current_user if current_user
      users << current_staff if current_staff
      if users.any?
        ::Ability::User.new(*users)
      else
        nil
      end
    end
  end

  def set_server_hostname_header
    headers['X-HEJIA-SERVER'] = Socket.gethostname
  end
end
