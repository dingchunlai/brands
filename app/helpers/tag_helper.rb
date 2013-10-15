module TagHelper
  extend ActiveSupport::Memoizable

  # 所有的品类选项，返回的结果给select方法作为choices参数使用。
  # 参看：http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#M001624
  def category_select_collection
    Tag.all_categories.map { |tag| [tag.TAGNAME, tag.TAGID] }
  end
  memoize :category_select_collection
 
  # 所有品类的checkbox列表
  def category_checkbox_list(selected_categories, dom_name_prefix)
    selected = (selected_categories || []).inject({}) { |hash, tag| hash[tag.TAGID] = true; hash }
    content_tag :ul, :class => 'horizontal' do
      Tag.all_categories.inject('') do |html, tag|
        html << content_tag(:li) do
          check_box_tag("#{dom_name_prefix}[tags][#{tag.TAGID}]", '1', selected[tag.TAGID], :id => "#{dom_name_prefix}_tags_#{tag.TAGID}") << "<label>#{tag.TAGNAME}</label>"
        end
      end
    end
  end
  memoize :category_checkbox_list

  # 所有品类的checkbox列表
  def production_category_checkbox_list(tag_id, selected_categories, dom_name_prefix)
    selected = (selected_categories || []).inject({}) { |hash, tag| hash[tag.id] = true; hash }
    content_tag :ul, :class => 'horizontal' do
      ProductionCategory.for_tag(tag_id).inject('') do |html, tag|
        html << content_tag(:li) do
          check_box_tag("#{dom_name_prefix}[categories][#{tag.id}]", '1', selected[tag.id], :id => "#{dom_name_prefix}_categories_#{tag.id}") << "<label>#{tag.name}</label>"
        end
      end
    end
  end
  memoize :production_category_checkbox_list


  # 创建一个品类连接：<a href="/品类也地址">品类名称</a>
  # @param [Tag] tag 品类
  # @param [Hash] options 可选项，传入到link_to方法中。
  def link_to_tag(tag, options={})
    tag_path = LINK_URLS['尚未开通品类'][tag.TAGNAME]
    options = {:alt => tag.TAGNAME}.merge options
    link_to tag.TAGNAME, tag_path || show_pinlei_url(:subdomain => tag.TAGURL), options
  end
end
