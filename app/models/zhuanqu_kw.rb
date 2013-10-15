class ZhuanquKw < Hejia::Db::Hejia
  set_table_name "zhuanqu_kws"
  
  belongs_to :sort, :class_name => "ZhuanquSort", :foreign_key => "sort_id"

  def readonly?
    defined?(@readonly) && @readonly == true
  end
  
  def self.get_kw_names_by_sort_id(sort_id)
    ZhuanquKw.find(:all,:select=>"id, kw_name",:conditions=>"sort_id = #{sort_id} and is_delete = 0 and is_published = 1").map{|r| r.kw_name}
  end

  def self.get_zhuanqu_kws(board_id)
    memkey = "ZhuanquKw:get_zhuanqu_kws:#{board_id}:all"
    keywords = Rails.cache.fetch(memkey, :expires_in => 1.day) do
      ZhuanquKw.find(:all,:conditions=>"sort_id in (#{ZhuanquSort.get_sorts_by_board_id(board_id).map{|z|z.id}.join(',')}) and is_delete = 0 and is_published = 1").sample(120)
    end
    keywords
  end

end
