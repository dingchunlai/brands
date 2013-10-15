module PrettyAdminHelper
  def render_navigation_partial
    partial = @navigation_partial || controller.class.navigation_partial
    render :partial => partial if partial
  end

  def render_menu_partial
    logger.info "==> render menu_partial"
    partial = @menu_partial || controller.class.menu_partial
    logger.info "==> paritial name: #{partial.inspect}"
    render :partial => partial if partial
  end

  # Generate menu partial for left-column.
  def menu(*menus)
    if menus.size == 1
      menu_item menus.first, :class => 'link'
    else
      content = "<h3>#{menus.shift}</h3>"
      content << '<ul class="nav">'

      last_item = menus.pop

      menus.inject(content) { |content, item|
        content << "<li>#{menu_item item}</li>"
      }

      content << %'<li class="last">#{menu_item last_item}</li>' << '</ul>'
    end
  end

  # Used by `menu`.
  def menu_item(menu_item, options = nil)
    case menu_item
    when Array
      link_to menu_item.first, menu_item.last || '#', options
    else
      menu_item
    end
  end

  def top_bar(options)
    content_tag 'div', :class => 'top-bar' do
      content = ''

      
      if button = options[:button]
        content << link_to(button.first, button.last, :class => 'button')
      end

      content << "<h1>#{options[:title]}</h1>" if options[:title]

      if breadcrumbs = options[:breadcrumbs]
        content << content_tag('div', :class => 'breadcrumbs') do
          breadcrumbs.map { |text, link| link_to text, link }.join(' / ')
        end
      end

      content << '<br />'
    end
  end
  
  #控制当前选中MENU
   def active_top_menu name
     if name.is_a?(Array)
       %{ class="active" } if name.include?(controller_name)
     else
       %{ class="active" } if controller_name == name
     end
   end

#   # 中文化 ERROR MESSAGES FOR
#   def error_messages_for(object_name, options = {})
#       options = options.symbolize_keys
#       object = instance_variable_get("@#{object_name}")
#       unless object.errors.empty?
#         error_lis = []
#         object.errors.each{ |key, msg| error_lis << content_tag("li", msg) }
#         content_tag("div", content_tag(options[:header_tag] || "h2", "发生#{object.errors.count}个错误" ) +
#         content_tag("ul", error_lis), "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation" )
#       end
#   end

end
