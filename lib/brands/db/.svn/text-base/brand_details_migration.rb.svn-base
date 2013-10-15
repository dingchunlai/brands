require 'singleton'

require 'action_controller'
require 'action_controller/test_process'

# we redefine models to make sure that the program run correctly.
begin
  ::Object.send :remove_const, 'Brand'
rescue NameError
  # Brand is not loaded yet, that's fine.
end

class Brand < ActiveRecord::Base
  set_table_name 'product_brands'

  has_many :logos,   :class_name => 'BrandPicture'
  has_many :details, :class_name => 'BrandDetail'
  has_many :tagged_brands

  def tags
    @tags ||= tagged_brands.map { |tb| tb.tag }
  end

  def migrate_details
    return if tags.blank? # 没有和品类关联的品牌不作处理

    detail =
      if details.blank?
        details.build
      elsif details.size == 1 && (details.first.tag_id.blank? || details.first.tag_id == 0)
        details.first
      else
        nil
      end

    return if detail.nil? # 认为这个品牌的记录已经处理过了

    # 先和第一个品类关联起来，把信息补充完整
    detail.attributes = {
      :tag_id => tags.first.TAGID,
      :website => website,
      :comment => comment,
      :description => description,
      :contact => manufacturer
    }

    detail.save!

    tags[1..-1].each do |tag|
      details.create :tag_id => tag.TAGID,
        :website       => detail.website,
        :comment       => detail.comment,
        :description   => detail.description,
        :contact       => detail.contact,
        :sale_network  => detail.sale_network,
        :demonstration => detail.demonstration,
        :cases         => detail.cases,
        :service       => detail.service,
        :specialty     => detail.specialty
    end
  end

  def migrate_logos
    return if tags.blank? # 没有和品类关联的品牌不作处理

    # 只处理上传过logo，并且logo还没有跟品类关联的情况
    if logos.size == 1 && (logo = logos.first) && (logo.tag_id.blank? || logo.tag_id == 0)
      logo.update_attribute :tag_id, tags.first.TAGID
      filename  = logo.full_filename
      mime_type = logo.content_type

      tags[1..-1].each do |tag|
        bp = BrandPicture.new :brand_id => id,
          :tag_id => tag.TAGID,
          :uploaded_data => ActionController::TestUploadedFile.new(filename, mime_type)
        bp.save!
      end if File.file?(filename)
    end
  end
end

module Brands
  module DB
    class BrandDetailsMigration
      include Singleton

      def run!
        Brand.all(:include => [:logos, :details, {:tagged_brands => :tag}]).each do |brand|
          brand.migrate_details
          brand.migrate_logos
        end
      end
    end
  end
end
