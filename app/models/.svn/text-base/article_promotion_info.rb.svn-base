class ArticlePromotionInfo < ActiveRecord::Base
  set_table_name 'article_promotion_info'

  has_one :picture, :class_name => 'ProductPicture', :as => :attachable

  named_scope :article_ids_by_brand, lambda { |brand_id, limit|
    brand_id = brand_id.id if brand_id.is_a?(Brand)
    {
      :select => "article_id",
      :conditions => ["brand_id = ? and brand_index_priority > 0", brand_id],
      :order => "brand_index_priority asc",
      :limit => limit
    }
  }

  class << self

    def articles_by_brand(brand_id, limit=6)
      articles = []
      self.article_ids_by_brand(brand_id, limit).each do |r|
        article = Article.find(r.article_id, :select=>"ID, TITLE, CREATETIME") rescue nil
        articles << article unless article.nil?
      end
      articles
    end

    # 为首页提取热点评测文章(带图)所写方法
    # 取得推广文章信息
    # 并且带图的
    def has_image_promotion(limit)
      find(:all,
        :select => "article_id",
        :joins => "join pictures as pic on pic.attachable_id = article_promotion_info.id",
        :conditions => "index_priority != 0 and pic.attachable_type = 'ArticlePromotionInfo'",
        :limit => limit
      )
    end
    
    # 为首页提取热点评测文章（不带图）所写方法
    # 取得推广文章
    def index_promotions(limit)
      find(:all,
        :select => "article_id",
        :conditions => ["index_priority != 0"],
        :limit => limit
      )
    end
  end
end
