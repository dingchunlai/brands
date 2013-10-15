module Dianping::DecoServicesHelper

  def previous_deco_service_link previous_deco_service
    if previous_deco_service
      link_to "上一篇：#{previous_deco_service.title}", deco_service_url(:id => previous_deco_service.id)
    else
      ""
    end
  end

  def next_deco_service_link next_deco_service
    if next_deco_service
      link_to "下一篇：#{next_deco_service.title}", deco_service_url(:id => next_deco_service.id)
    else
      ""
    end
  end

end