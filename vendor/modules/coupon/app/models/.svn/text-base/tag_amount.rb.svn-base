class TagAmount < ActiveRecord::Base

  belongs_to :tag, :primary_key => 'TAGID', :foreign_key => 'tag_id', :class_name => 'Industry'
  belongs_to :print_record
  
  validates_presence_of :tag_id, :amount, :print_record_id
  validate :must_be_tag

  def must_be_tag
    errors.add_to_base("此行业信息已经添加 ") unless TagAmount.find_by_tag_id_and_print_record_id(tag_id, print_record_id).blank?
  end
  
end
