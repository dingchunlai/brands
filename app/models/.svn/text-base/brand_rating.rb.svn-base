class BrandRating < ActiveRecord::Base
  belongs_to :brand

  before_create :set_default_values
  before_save   :calculate_score

  class << self
    def rating_items
      @rating_items ||= column_names - ['score', 'id', 'brand_id']
    end

    # 验证一个评价项是否合法，如果是，则返回该项，否则返回nil
    def validate_rating_item item
      item if rating_items.include?(item.to_s)
    end
  end

  private
  def set_default_values
    (self.class.rating_items).each do |item|
      item = 0 unless item
    end
  end

  def calculate_score
    score1 = good + bad
    score1 = ( score1 == 0 ? 0 : 1.0 * good / score1 )
    self.score =
      (50 * score1 +
      %w[quality service reputation cost known].inject(0) { |sum, name|
        total = (send("#{name}_good") + send("#{name}_bad"))
        sum += ( total == 0 ? 0 : (10.0 * send("#{name}_good") / total) )
      }).round / 10.0
  end
end
