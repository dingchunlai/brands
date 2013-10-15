class HtmlMetadata < Hejia::Db::Hejia
  set_table_name 'html_metadata'
  # set_primary_key 'url'
  
  named_scope :with_tag_brand, lambda {|tagurl, brand_permalink|
    tagurl = tagurl.is_a?(Tag) ? tagurl.TAGURL : tagurl
    brand_permalink = brand_permalink.is_a?(Brand) ? brand_permalink.permalink : brand_permalink
    {
      :conditions => ["url = ?", (['staging', 'development'].include?(RAILS_ENV) ? "http://#{tagurl}.51hejia.com:5000/#{brand_permalink}" : "http://#{tagurl}.51hejia.com/#{brand_permalink}")]
    }
  }


end
