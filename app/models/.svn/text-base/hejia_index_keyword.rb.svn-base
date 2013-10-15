class HejiaIndexKeyword < Hejia::Db::Index
  set_table_name "hejia_index_keywords"
  def readonly?
    defined?(@readonly) && @readonly == true
  end
  
  def self.get_id_by_keyword(keyword)
    r = HejiaIndexKeyword.find(:first, :select=>"id", :conditions=>["name = ?", keyword])    
    if r.nil?
       0
    else
       r.id
    end
  end
  
  def self.get_keywords_by_index_id(index_id, limit=15)
     HejiaIndexKeyword.find(:all, :select=>"k.name", :joins=>"k, hejia_indexes_keywords ik", :conditions=>"k.id = ik.keyword_id and ik.index_id = #{index_id}", :limit => limit).map{|r| r["name"]}.uniq
   end
  
end
