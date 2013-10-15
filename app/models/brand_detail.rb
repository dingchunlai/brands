class BrandDetail < ActiveRecord::Base
  belongs_to :brand

  DETAIL_ATTR = {
    'description' => '品牌概要',
    'sale_network' => '网络销售',
    'demonstration' => '门店展示',
    'cases' => '工程案例',
    'service' => '售后服务',
    'specialty' => '技术特点',
    'story' => '品牌故事',
    'history' => '品牌历程'
  }.freeze
end
