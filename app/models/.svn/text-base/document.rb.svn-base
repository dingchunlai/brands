class Document < ActiveRecord::Base
  belongs_to :brand, :counter_cache => true

  validates_presence_of :name
  validates_presence_of :brand_id

  has_attachment :storage => :file_system

  def download_link
    url.blank? && public_filename || url
  end
end
