class CloudPicture < Hejia::Db::Hejia
  set_table_name "pictures"
  
  belongs_to :item, :polymorphic => true


  # 可以这样获取图片 <%= cloud_fs_url_for(@cloud_picture.url)%>
  def url
    self.image_id + "-" + self.image_md5 + "." + self.image_ext
  end

end
