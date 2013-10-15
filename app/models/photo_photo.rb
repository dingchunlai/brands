class PhotoPhoto < Hejia::Db::Hejia

  has_and_belongs_to_many :tags, :join_table => "table_name", :foreign_key => "tags_id"


  has_and_belongs_to_many :tags, 
     :class_name => "CaseTag",
     :join_table => "HEJIA_TAG_ENTITY_LINK",
     :foreign_key => "ENTITYID",
     :association_foreign_key => "TAGID",
     :conditions =>["LINKTYPE = 'case'"],
     :group =>"HEJIA_TAG.TAGFATHERID"

  def self.get_dantus(keyword, page=1)
    page = 1 if page.to_i < 1
    kw = get_key("mk_photo_dantusss", keyword, page)
    return get_memcache(kw, RAILS_ENV=="production" ? 1.hour : 1.second) do
      self.dantus(keyword, page)
    end
  end

  def self.dantus(keyword, page=1)
    PhotoPhoto.paginate(:select => "pp.id,pp.case_id,pp.type_id, pp.filepath",
      :conditions => self.dantus_conditions(keyword),
      :joins => "pp, photo_photos_tags ppt",
      :order => "id desc",
      :total_entries => self.dantus_counter(keyword),
      :page => page.to_i)
  end

  def self.dantus_counter(keyword)
    kw = get_key("mk_dantusss_counter", keyword)
    return get_memcache(kw, RAILS_ENV=="production" ? 1.hour : 1.second) do
      PhotoPhoto.count("pp.id", :conditions=>self.dantus_conditions(keyword), :joins=>"pp, photo_photos_tags ppt")
    end
  end
  
  def self.dantus_conditions(keyword)
    keywords = ZhuanquDantu.get_dantu_keywords(keyword)
    conditions = []
    if keywords.length > 1 #如果是复合词，则使用分词子搜索条件
      photo_ids = PhotoPhoto.find(:all, :select => "pp.id",
        :conditions => "ppt.tag_id = #{get_photo_tag_id(keywords[0].gsub("|","/"))} and pp.id = ppt.photo_id and pp.type_id in (3,5)",
        :joins => "pp, photo_photos_tags ppt", :limit => 30000).collect{ |r| r.id }.join(",")
      tag_id = get_photo_tag_id(keywords[1].gsub("|","/"))
      conditions << "pp.id in (#{photo_ids})" if photo_ids.to_s.length > 0
    else  #如果是单词
      tag_id = get_photo_tag_id(keyword.gsub("|","/"))
    end
    conditions << "ppt.tag_id = #{tag_id}"
    conditions << "pp.id = ppt.photo_id and pp.type_id in (3,5)"
    conditions.join(" and ")
  end
  
  def self.get_case_id(kw) #通过关键词取得案例ID
    conditions = []
    conditions << "TAGESTATE='0' and TAGTYPE='case'"
    conditions << "TAGNAME='#{kw}'"
    tag_id = HejiaTag.find(:first,:select=>"TAGID",:conditions=>conditions.join(" and ")).TAGID rescue 0
    @case_keyword = kw if tag_id.to_i > 0
    return tag_id
  end
  
 def get_photo_url
    path_prefix = type_id == 5 ? "http://image.51hejia.com" : "http://image.51hejia.com/files/hekea/case_img/"
    path_prefix << filepath
  end

end
