module BrandRatingHelper
  def rating_bar_for(brand_rating, item)
    good = brand_rating.send "#{item}_good"
    bad  = brand_rating.send "#{item}_bad"

    sum = good + bad

    good_persent, bad_persent =
      if sum == 0
        [50, 50]
      else
        gp = (good * 100.0 / sum).floor
        [gp, 100 - gp]
      end

    content_tag :div, :id => "#{item}_rate_bar", :class => 'b_cylinder_ma' do
      content_tag(:ul) {
        content_tag(:li, good, :class => 'b_cylinder_mg', :style => "width: #{good_persent}%") +
        content_tag(:li, bad,  :class => 'b_cylinder_mb', :style => "width: #{bad_persent}%")
      } +
      %Q'<a title="#{good} / #{bad}"></a>'
    end
  end

  def rating_buttons_for(brand, item)
    good_url = pinpai_rate_path :permalink => brand.permalink, :item => "#{item}_good", :subdomain => false
    bad_url  = pinpai_rate_path :permalink => brand.permalink, :item => "#{item}_bad",  :subdomain => false
    # 两个input必须连在一起，否则页面就会被破坏
    %Q'<input type="button" value="好" class="b_cylinder_btng btn-rate" data-remote="#{good_url}" />' +
    %Q'<input type="button" value="坏" class="b_cylinder_btnb btn-rate" data-remote="#{bad_url}"  />'
  end

  def category_buttons_for(brand, item,category_id)
    good_url = categroy_rate_path :permalink => brand.permalink, :item => "#{item}_good", :subdomain => false,:category_id =>category_id
    bad_url  = categroy_rate_path :permalink => brand.permalink, :item => "#{item}_bad",  :subdomain => false,:category_id =>category_id
    # 两个input必须连在一起，否则页面就会被破坏
    %Q'<input type="button" value="好" class="b_cylinder_btng btn-rate" data-remote="#{good_url}" />' +
    %Q'<input type="button" value="坏" class="b_cylinder_btnb btn-rate" data-remote="#{bad_url}"  />'
  end


end
