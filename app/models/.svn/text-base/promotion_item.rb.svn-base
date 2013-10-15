class PromotionItem < ActiveRecord::Base

  include CloudFsHelper

  belongs_to :promotion_collection

  validates_presence_of :priority

  default_scope :order => 'priority, published_at DESC'

  named_scope :published, lambda { {:conditions => ['published_at <= ?', Time.zone.now]} }

  attr_accessor :resource

  named_scope :limit, lambda { |limit| {:limit => limit} }

  def title
    if @title.nil?
      chars_size = promotion_collection.chars_size.to_i
      if chars_size > 0
        @title = resource.promotion(:title).to_s.chars.first(chars_size).join
      else
        @title = resource.promotion(:title)
      end
    end
    @title
  end

  def url
    @url = resource.promotion(:url) if @url.nil?
    @url
  end

  def description
    resource.promotion(:description)
  end

  def content
    resource.promotion(:content)
  end

  #取得图片
  def image(thumbnail=nil)
    @image = cloud_fs_url_for(resource.image_url, :thumbnail => thumbnail) if @image.nil?
    @image
  end

end
