class BbsTag < Hejia::Db::Forum
  belongs_to :tag, :foreign_key => "brand_tag_id"
  belongs_to :brand #, :foreign_key => "brand_id"
  
  named_scope :with_tag_brand, lambda{ |tag_id, brand_id|
    {
      :conditions => ["brand_tag_id = ? and brand_id = ?", tag_id, brand_id]
    }
  }

  def topics(limit=8)
    BbsTopic.find(:all, :select=>"id,subject", :conditions=>["is_delete=0 and tag_id=?", id], :limit=>limit, :order => "id desc")
  end

end
