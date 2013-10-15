class ZhuanquSort < Hejia::Db::Hejia
  set_table_name "zhuanqu_sorts"
  
  def readonly?
    defined?(@readonly) && @readonly == true
  end
  
  def self.get_zhuanqu_sort sort_name
    ZhuanquSort.find(:first,:conditions=>["sort_name = ?", sort_name])
  end


  class << self

    def get_sort_id_by_sort_name(sort_name)
      kw_mc = "sort_id_by_sort_name_#{sort_name}"
      return get_mc(kw_mc, 0, 500) do
        self.find(:first, :select=>"id", :conditions=>"is_delete = 0 and sort_name = '#{sort_name}'")["id"] rescue 0
      end
    end

    def get_sorts_by_board_id(board_id)
      key = "zhuanqu_sorts_by_board_id_#{board_id}"
      rs = Hejia[:cache].fetch(key, 2.days) do
        board_id = board_id.to_i
        conditions = []
        conditions << "is_delete = 0 and is_published = 1"
        if board_id == 1
          conditions << "(board_id in (1,6))"
        else
          conditions << "board_id = #{board_id}"
        end
        ZhuanquSort.find(:all,:select=>"id, sort_name",:conditions=>conditions.join(" and "))
      end
      rs
    end

  end

end
