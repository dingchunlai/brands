class PublishColumn < ActiveRecord::Base
  self.table_name = "51hejia.publish_columns"
  has_many :contents, :class_name => "PublishContent", :conditions => ["is_del = ?", false]
  belongs_to :group, :class_name => "PublishColumnGroup", :foreign_key => "group_id"
  #  acts_as_readonlyable [:read_only_51hejia]

  def self.save(name, editor_id, description, is_valid)
    if name == ""
      #名称为空
    else
      pc = PublishColumn.find(:first, :select => "id",
        :conditions => ["editor_id = ? and is_valid != ? and name = ?", editor_id, 0, name])
      if pc.nil?
        pc_new = PublishColumn.new
        pc_new.name = name
        pc_new.editor_id = editor_id
        pc_new.description = description
        pc_new.is_valid = is_valid
        pc_new.save
      else
        #名称重复
      end
    end
  end

  def self.modify(id, name, description, is_valid)
    if name == ""
      #名称为空
    else
      pc = PublishColumn.find(:first, :conditions => ["id = ? and is_valid != ?", id, 0])
      pc.name = name
      pc.description = description
      pc.is_valid = is_valid
      pc.save
    end
  end

  def self.delete(id)
    pc = PublishColumn.find(:first, :conditions => ["id = ? and is_valid != ?", id, 0])
    pc.is_valid = 0
    pc.save
  end
end
