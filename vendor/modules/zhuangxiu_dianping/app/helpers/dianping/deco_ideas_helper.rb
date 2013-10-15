module Dianping::DecoIdeasHelper
  
  def previous_deco_idea_link previous_deco_idea
    if previous_deco_idea
      link_to "上一篇：#{previous_deco_idea.title}", deco_idea_url(:id => previous_deco_idea.id)
    else
      ""
    end
  end
  
  def next_deco_idea_link next_deco_idea
    if next_deco_idea
      link_to "下一篇：#{next_deco_idea.title}", deco_idea_url(:id => next_deco_idea.id)
    else
      ""
    end
  end
  
end