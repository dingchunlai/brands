class TaobaoArticle < HejiaIndex

  named_scope :keyword_id_eq, lambda { |keyword_id|{
  :select => "hejia_indexes.id, hejia_indexes.entity_type_id,entity_id, hejia_indexes.title, hejia_indexes.entity_created_at, hejia_indexes.resume, hejia_indexes.url, hejia_indexes.image_url, hejia_indexes.image_url2, hejia_indexes.image_url3, hejia_indexes.image_url4, hejia_indexes.image_url5",
   :joins => "hejia_indexes, hejia_indexes_keywords k",
   :conditions => ["hejia_indexes.id = k.index_id and k.keyword_id = ? and hejia_indexes.image_url is not null", keyword_id]
    }
  }
  
  KEYWORD = {
    "装修达人" => 32076, #s
    "产品评测导购" => 42092, #f
    "软装师" => 12418 #s
  }
  
end