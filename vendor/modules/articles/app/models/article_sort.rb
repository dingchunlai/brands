class ArticleSort < Hejia::Db::Hejia

  has_many :articles, :foreign_key => 'FIRSTCATEGORY', :conditions => ['STATE = 0'], :limit => 10
  
end
