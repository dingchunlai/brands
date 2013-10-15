class PublishContentKeyword < ActiveRecord::Base
  self.table_name = "51hejia.publish_content_keywords"
  validates_presence_of :title
  validates_presence_of :url
  belongs_to :publish_content
end
