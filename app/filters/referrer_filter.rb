# encoding: utf-8

# 访问来源filter。
# 确保访问来源符合要求。
# example:
# class SomeController < ApplicationController
#   # 访问来自google的
#   before_filter ReferrerFilter.new(/^http://google.com/)
#
#   # 访问来自51hejia.com的
#   before_filter ReferrerFilter.hejia_referrer
# end
class ReferrerFilter
  HEJIA_REFERRER = %r'^http://[^/]*\.51hejia\.com'.freeze

  def self.hejia_referrer
    new HEJIA_REFERRER
  end

  def initialize(referrer)
    @referrer = referrer
  end

  def filter(controller)
    (@referrer === controller.request.env['HTTP_REFERER']) || controller.send(:head, 403)
  end

end
