# encoding: utf-8

class ProductPicture < ActiveRecord::Base
  set_table_name 'pictures'

  belongs_to :attachable, :polymorphic => true

  has_attachment :content_type => :image,
    :storage => :file_system
    #resize_to => '???x???',
    #thumbnails => { :thumb => '???x???' }

  validates_as_attachment

  before_create :set_is_master

  # 是主图？
  def master?
    is_master == true || is_master == 1
  end

  # 设为主图
  def master!
    self.is_master = 1
    if save
      resolve_conflict
      true
    else
      false
    end
  end

  # 去掉主图属性
  def not_master!
    self.is_master = 0
    save
  end

  # 把其他主图的主图属性去掉
  def resolve_conflict
    self.class.update_all('is_master = 0', ["id <> ? and attachable_type = ? and attachable_id = ? and is_master <> 0", id, attachable_type, attachable_id])
  end

  private
  # 新添加的图片，除非指定，否则不设为主图
  def set_is_master
    self.is_master = 0 unless self.is_master
  end
end
