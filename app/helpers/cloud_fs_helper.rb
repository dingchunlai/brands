module CloudFsHelper
  @@cloud_fs_asset_domain_size = 3

  # 生成符合cloud_fs规则的文件地址。
  # @param [String] filename 文件名称（cloud_fs的文件名称）
  # @param [Hash] options 选项
  # @option [String] :type 文件类型，涉及到域名的生成。如：'image', 'js'。
  # @option [String] :thumbnail 缩略图大小。如：'40', '100x50'等。
  def cloud_fs_url_for(filename, options = nil)
    filename.sub!("/", "")
    if thumb = options.try(:[], :thumbnail)
      extname = File.extname filename
      filename = "#{File.basename(filename, extname)}_#{thumb}#{extname}"
    end
    cloud_fs_domain(options.try(:[], :type) || 'image') + filename
  end

  # 得到cloud_fs下载文件的域名。
  # @param [String] file_type 文件类型，涉及到域名的生成。如：'image', 'js'。
  def cloud_fs_domain(file_type)
=begin
     if RAILS_ENV == "development" ||  RAILS_ENV == "staging"
       "http://192.168.0.15:8081/"
     else
       "http://assets#{rand(@@cloud_fs_asset_domain_size) + 1}.#{file_type}.51hejia.com/"
     end
=end
     "http://assets#{rand(@@cloud_fs_asset_domain_size) + 1}.#{file_type}.51hejia.com/"
  end

  # 得到cloud_fs的上传地址。
  # @param [String] file_type 文件类型，涉及到域名的生成。如：'image', 'js'。
  def cloud_fs_upload_path(file_type)
=begin
  if RAILS_ENV == "development" ||  RAILS_ENV == "staging"
      "http://192.168.0.15:8081"
    else
      "http://upload.#{file_type}.51hejia.com/"
    end
=end
    "http://upload.#{file_type}.51hejia.com/"
  end

end
