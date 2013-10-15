class PromotionPagePart < ActiveRecord::Base
  
  # 多态关联
  belongs_to :page, :polymorphic => true  

=begin
  def page_type=(page_tpye)
    super(page_type.to_s.classify.constantize.base_class.to_s)
  end
=end
end
