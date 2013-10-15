require 'singleton'

# we redefine models to make sure that the program run correctly.
begin
  ::Object.send :remove_const, 'Brand'
rescue NameError
  # Brand is not loaded yet, that's fine.
end

class Brand < ActiveRecord::Base
  set_table_name 'product_brands'
  
  has_many :ratings, :class_name => 'BrandRating'
  has_many :tagged_brands
  
  def tags
    @tags ||= tagged_brands.map{|tb| tb.tag }
  end 
  
  def migrate_ratings
    return if tags.blank? 
    return unless ratings.size == 1 && (ratings.first.tag_id.blank? || ratings.first.tag_id == 0)

    rating = ratings.first
    
    rating.tag_id = tags.first.TAGID
    rating.save!
    
    tags[1..-1].each do |tag|
      ratings.create :tag_id => tag.TAGID,
        :good                 => rating.good,
        :soso                 => rating.soso,
        :bad                  => rating.bad,
        :quality_good         => rating.quality_good,
        :quality_bad          => rating.quality_bad,
        :service_good         => rating.service_good,
        :service_bad          => rating.service_bad,
        :reputation_good      => rating.reputation_good,
        :reputation_bad       => rating.reputation_bad,
        :cost_good            => rating.cost_good,
        :cost_bad             => rating.cost_bad,
        :known_good           => rating.known_good,
        :known_bad            => rating.known_bad
    end
    
  end
end

module Brands
  module DB
    class BrandRatingsMigration
      include Singleton

      def run!
        Brand.all(:include => [:ratings, {:tagged_brands => :tag}]).each do |brand|
          brand.migrate_ratings
        end
      end
    end
  end
end
