class Api::BaseController < ApplicationController
  # 所有api通过另外的方式来验证
  skip_before_filter :verify_authenticity_token
  skip_before_filter :get_promotion_items_for_layout
  
end
