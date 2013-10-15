class Zhuangxiuzixun::ApplicationController < ApplicationController
  
  helper :all
  skip_before_filter :get_promotion_items_for_layout, :brand_validation_filter

end