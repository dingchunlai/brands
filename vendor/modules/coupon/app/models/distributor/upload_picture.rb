# encoding : utf-8

class Distributor::UploadPicture < Hejia::Db::Product
  # 之所以命名为UploadPicture而不为picture:
  # 由于Distirubutor 已有 has_many :pictures
  # 若使用Picture命名则  那么Distributor has_many :pictures class_name 选项需指定为 "::Picture"
  belongs_to :resource, :polymorphic => true
  has_many :distributors, :source_type => :resource

  validates_presence_of :image_url, :message => "请选择图片进行上传"
  validates_presence_of :name
  validates_length_of :summary, :maximum=>200, :if => Proc.new { |p| !p.summary.blank? }

  def self.unaudited
    find(
        :all,
        :select => " distributor_upload_pictures.resource_type, distributor_upload_pictures.id, "\
                   " distributor_upload_pictures.name, distributor_upload_pictures.image_url, "\
                   " distributor_picture_types.class_name as image_type, distributors.id as distributor_id, distributors.title as distributor_title ",
        :conditions => ["approval_status = ?", false],
        :joins => " join distributor_picture_types on distributor_picture_types.id = distributor_upload_pictures.resource_id "\
                  " join distributors on distributors.id = distributor_picture_types.distributor_id "
    )
  end

  def self.audited_by_distributor(distributor_id)
    find(
        :all,
        :select => " distributor_upload_pictures.resource_type, distributor_upload_pictures.id, "\
                   " distributor_upload_pictures.name, distributor_upload_pictures.image_url, "\
                   " distributor_picture_types.class_name as image_type, distributors.id as distributor_id, distributors.title as distributor_title ",
        :conditions => ["approval_status = ? and distributor_picture_types.distributor_id = ? ", true, distributor_id],
        :joins => " join distributor_picture_types on distributor_picture_types.id = distributor_upload_pictures.resource_id "\
                  " join distributors on distributors.id = distributor_picture_types.distributor_id "
    )    
  end

end