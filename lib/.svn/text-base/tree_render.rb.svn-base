module TreeRender
    protected
    def render_permission_tree(nodes, permission_groups, current_permissions, parent=nil)
      result = "<ul#{parent.nil? ? ' id="tree"' : ""}>\n"
      nodes[parent].each do |node|
        if nodes[node.id]
          result << "<li><span id='group_#{node.id}' data='group'>#{node.id}-#{node.title}</span>"
          result << render_permission_tree(nodes, permission_groups, current_permissions, node.id)
          result << "</li>\n"
        else
          if permission_groups[node.id]
            result << "<li><span id='group_#{node.id}' data='permission'>#{node.id}-#{node.title}</span>"
            result << "<ul>\n"
            permission_groups[node.id].each do |permission|
              result << "<li id='permission_item_#{permission.id}'>\n"
#              result << "<span id='peritem_desc_#{permission.id}'>[动作 #{permission.action} | 对应 #{permission.subject_class.to_s.singularize.classify}]</span>"
              result << "<span id='peritem_title_#{permission.id}'>#{permission.title}</span>"
              if current_permissions.include? permission.id
                result << "<input type='checkbox' id='permission_#{permission.id}' name='permission_#{permission.id}' value='#{permission.id}' checked />"
              else
                result << "<input type='checkbox' id='permission_#{permission.id}' name='permission_#{permission.id}' value='#{permission.id}' />"
              end
              result << "</li>\n"
            end
            result << "</ul>\n</li>\n"
          else
            result << "<li><span id='group_#{node.id}' data='both'>#{node.id}-#{node.title}</span>"
            result << "</li>\n"
          end
        end
      end
      result << "</ul>\n"
    end


    def self.included(base)
      base.send :helper_method, :render_permission_tree if base.respond_to? :helper_method
    end

 end
__END__
    def render_mytree(nodes, permission_groups, current_permissions, parent=nil)
      result = "<ul#{parent.nil? ? ' id="tree"' : " id=\"parent_group_#{parent}\""}>\n"
      nodes[parent].each do |node|
        if nodes[node.id]
          result << "<li id='li_group_#{node.id}'><span id='group_#{node.id}'>#{node.id}-#{node.title}</span>"# <a id='g_#{node.id}'>+分组</a> <a id='gp_#{node.id}'>+权限</a>"
          result << render_mytree(nodes, permission_groups, current_permissions, node.id)
          result << "</li>\n"
        else
          result << "<li id='li_group_#{node.id}'><span id='group_#{node.id}'>#{node.id}-#{node.title}</span>"#  <a id='g_#{node.id}'>+分组</a> <a id='gp_#{node.id}'>+权限</a>" #node
          if permission_groups[node.id]
            result << "<ul id='permissions_g_#{node.id}'>\n"
            permission_groups[node.id].each do |permission|
              result << "<li id='li_permission_#{permission.id}'>\n"
              result << "Permisson-#{permission.id} - #{permission.title}&nbsp;&nbsp;"
              if current_permissions.include? permission.id
                result << "<input type='checkbox' id='permission_#{permission.id}' name='permission_#{permission.id}' value='#{permission.id}' checked>"#check_box_tag("permission_#{permission.id}", "#{permission.id}", true)
              else
                result << "<input type='checkbox' id='permission_#{permission.id}' name='permission_#{permission.id}' value='#{permission.id}'>"#check_box_tag("permission_#{permission.id}", permission.id)
              end
              result << "&nbsp;对应动作 #{permission.action} | 对应模型 #{permission.subject_class.to_s.singularize.classify}"
              result << "</li>\n"
            end
            result << "</ul>\n</li>\n"
          else
            result << "</li>\n"
          end
        end
      end
      result << "</ul>\n"
    end

    def render_mytree(nodes, permission_groups, current_permissions, parent=nil)
      result = "<ul#{parent.nil? ? ' id="tree"' : ""}>\n"
      nodes[parent].each do |node|
        if nodes[node.id]
          result << "<li>(有子组-只能添加子组-不可添加权限-不可删除)<span id='group_#{node.id}' data='group'>#{node.id}-#{node.title}</span>"
          result << render_mytree(nodes, permission_groups, current_permissions, node.id)
          result << "</li>\n"
        else
          if permission_groups[node.id]
            result << "<li>(有子权限-只能添加权限-不可添加分组-不可删除)<span id='group_#{node.id}' data='permission'>#{node.id}-#{node.title}</span>"
            result << "<ul>\n"
            permission_groups[node.id].each do |permission|
              result << "<li>\n"
              result << "Permisson-#{permission.id} - #{permission.title}&nbsp;&nbsp;"
              if current_permissions.include? permission.id
                result << "<input type='checkbox' id='permission_#{permission.id}' name='permission_#{permission.id}' value='#{permission.id}' checked>"#check_box_tag("permission_#{permission.id}", "#{permission.id}", true)
              else
                result << "<input type='checkbox' id='permission_#{permission.id}' name='permission_#{permission.id}' value='#{permission.id}'>"#check_box_tag("permission_#{permission.id}", permission.id)
              end
              result << "&nbsp;对应动作 #{permission.action} | 对应模型 #{permission.subject_class.to_s.singularize.classify}"
              result << "</li>\n"
            end
            result << "</ul>\n</li>\n"
          else
            result << "<li>(无子权限-可添子组或权限-可删除)<span id='group_#{node.id}' data='both'>#{node.id}-#{node.title}</span>"
            result << "</li>\n"
          end
        end
      end
      result << "</ul>\n"
    end