class PaintKeywordArticle < Hejia::Db::Hejia
	belongs_to :paint_keyword, :class_name => "PaintKeyword", :foreign_key => "paint_keyword_id"
	belongs_to :article, :class_name => "Article", :foreign_key => "article_id"
	def self.articles(order = "HEJIA_ARTICLE.ID desc")
		Article.find(:all, :select => "distinct HEJIA_ARTICLE.*", :joins => "join paint_keyword_articles as pka on HEJIA_ARTICLE.ID=pka.article_id", :order => "#{order}")
	end
end