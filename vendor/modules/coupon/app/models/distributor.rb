class Distributor < ActiveRecord::Base 
  include Hejia::Impression
  wraps :add_impression

  has_one :distributor_decofirm
  has_one :deco_firm, :through => :distributor_decofirm

  #has_one :account_profile, :class_name => "DistributorAccountProfile"
  #has_one :bbs_account, :through => :account_profile, :source => :distributor_account

  after_create do |record|
    record.code = "#{record.id.to_s.rjust(6,"0")}"
    record.save
  end

  validates_presence_of :title, :short_title
  validates_uniqueness_of :title
  validates_format_of :qq, :with => /\A\d*\Z/, :unless => Proc.new { |d| d.qq.blank? }

#  attr_accessor :valid_contracts
  
  has_many :contracts, :conditions => {:deleted => false}
  has_many :pictures, :as => :item
  has_many :shops, :conditions => {:deleted => false}
  has_many :coupons, :conditions => {:deleted => false}

  # 会员上传
  HY_PIC_UPLOAD_LIMIT = {:shop => 1, :case => 999, :glory => 999}
  has_many :pictypes, :class_name => "Distributor::PictureType" do
    def shop
      self.find(:all, :conditions => {:class_name => "Distributor::PictureType::Shop"})
    end

    def case
      self.find(:all, :conditions => {:class_name => "Distributor::PictureType::Case"})
    end

    def glory
      self.find(:all, :conditions => {:class_name => "Distributor::PictureType::Glory"})
    end
  end

  default_scope :conditions => ["deleted = ?", false]

  named_scope :search, lambda { |title|
    {
      :conditions => title.blank? ? nil : ["title like ?", "%#{title}%"],
      :select => 'id, title'
    }
  }

  # 根据某属性进行排序
  # Exp: downloads_count
  named_scope :order_for_attr, lambda { |attr|
    {
      :order => "#{attr} DESC"
    }
  }

  # 根据合同锁定经销商
  named_scope :with_contracts, lambda {|contract_ids|
    ids = Distributor::Contract.find(contract_ids).map(&:distributor_id).uniq
    {:conditions => ["id in (?)", ids]}
  }

  named_scope :with_title, lambda { |title|
    {
      :conditions => title.blank? ? nil : ["title like ?", "%#{title}%"]  
    }
  }

  # 根据ID查询
  named_scope :with_ids, lambda { |ids|
    {
      :conditions => ids.blank? ? nil : ["id in (?)", ids]  
    }
  }

  named_scope :with_code, lambda { |code|
    {
      :conditions => code.blank? ? nil : ["code like ?", "%#{code}%"]  
    }
  }

  named_scope :with_sign_status, lambda { |status|
    case status
      when nil
        select = "distributors.*, (select count(id) from distributor_contracts where start_date <= '#{Time.zone.today}' and end_date >= '#{Time.zone.today}' and distributor_contracts.distributor_id=distributors.id and distributor_contracts.deleted = 0) as valid_contracts"
        conditions = nil
      when "1"
        select = "distributors.*, '1' as valid_contracts"
        conditions = "(select count(id) from distributor_contracts where start_date <= '#{Time.zone.today}' and end_date >= '#{Time.zone.today}' and distributor_contracts.distributor_id=distributors.id and distributor_contracts.deleted = 0) > 0"
      when "0"
        select = "distributors.*, '0' as valid_contracts"
        conditions = "(select count(id) from distributor_contracts where start_date <= '#{Time.zone.today}' and end_date >= '#{Time.zone.today}' and distributor_contracts.distributor_id=distributors.id and distributor_contracts.deleted = 0) = 0"
    end
    {
      :conditions => conditions,
      :select => select      
    }
  }

  def mark_deleted
  
    begin
      Distributor.transaction do
        update_attributes(:deleted => true)
        self.contracts.each do |contract|
          Distributor::Contract.transaction do
            contract.mark_deleted
          end
        end
        self.shops.each do |shop|
          Distributor::Shop.transaction do
            shop.mark_deleted
          end
        end
      end
    rescue
      raise
    end
  end

  named_scope :like_title, lambda { |str|
    if str.blank?
      {}
    else
      { :conditions => ["title like ?", "%#{str}%"]}
    end
  }
  
  def increase_pv_count
    update_attribute :pv, self.pv.to_i + 1
  end

  # === class_method ==  
  class << self
    def record_by_id(id)
      if id.to_i > 0
        Distributor.first(:select => 'id, title', :conditions => ['id = ?', id])
      else
        nil
      end
    end

    def id_to_title(object)
      object = record_by_id(object) if object.class != self
      return '' if object.nil?
      object.title
    end

    # 查询有效经销商数量
    def valid_count(distributor_ids = nil)
      unless distributor_ids.blank?
        if distributor_ids.is_a?(Array)
          distributor_ids.size
        else
          Distributor.count('id')
        end
      else
        Distributor.count('id')
      end
    end
  end

  # 诚信
  class ChengXin < Distributor
    set_inheritance_column :class_name
  end

  # 会员
  class HuiYuan < Distributor
    set_inheritance_column :class_name
  end

  # 低价
  class DiJia < Distributor
    set_inheritance_column :class_name
  end

  def impression_key
    "coupons:distributor:#{self.id}:impressions"
  end

  def counter_key 
    "coupons:distributor:#{self.id}:impressions:counter"
  end

  def latest_list_key 
    "coupons:distributor:#{self.id}:latest"
  end

  def impression_validate_limit_key
    "coupons:distributor:#{self.id}:impression:"
  end

end


