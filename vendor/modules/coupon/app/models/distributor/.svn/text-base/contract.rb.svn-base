class Distributor::Contract < ActiveRecord::Base

  validates_presence_of :title, :start_date, :end_date, :radmin_user_id
  #  validates_format_of :start_date, :end_date, :with => /((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))/
  #  validates_format_of :start_date, :with => /^2\d\d\d-[01]?\d-[0123]?\d$/
  #  validates_format_of :end_date, :with => /^2\d\d\d-[01]?\d-[0123]?\d$/
  #  validates_format_of :discount_rate, :with => /^[1-9]\d$/

  default_scope :deleted => false

  validates_uniqueness_of :code

  belongs_to :distributor, :counter_cache => true
  belongs_to :radmin_user

  named_scope :with_title, lambda{ |title| {
      :conditions => ['title LIKE ?', "%#{title}%"] 
    }
  }

  named_scope :with_user, lambda{|user|
    {
      :conditions => ['radmin_user_id = ?', user]
    }
  }

  named_scope :include_association, lambda { |association|
    {
        :include => association
    }
  }

  # 查找有效的合同
  named_scope :valid, :conditions => ["? >= start_date and ? <= end_date and deleted = ?", Time.zone.today, Time.zone.today, false]

  named_scope :by_distributor, lambda{ |distributor|
      { :conditions => ["distributor_id = ?", distributor] }
  }

  # 查找有效的合同 无缓存
  def self.valid_contracts(distributor)
    uncached do
      find(:all, :conditions => ["distributor_id = ? and ? >= start_date and ? <= end_date and deleted = ?", distributor, Time.zone.today, Time.zone.today, false ])
    end
  end

  # for distributor contracts statistic
  def group_with_statistic_logic
    now = Time.zone.today

    if (now >= start_date) and (now <= end_date)
      "valid"
    else
      "expired"
    end
  end

  # for distributor contracts statistic
  def self.statistic_by_distributor(distributor)
    raise if distributor.nil?
    contracts = find(
      :all,
      :select => "id, start_date, end_date",
      :conditions => ["distributor_id = ? and deleted = ?", distributor, false]
    )
    statistic_struct = Struct.new(:status, :contracts)
    contracts.group_by(&:group_with_statistic_logic).inject([]) { |arr ,value | arr << statistic_struct.new(value[0], value[1]) }
  end

  def mark_deleted
    if update_attribute :deleted, true
      Distributor.decrement_counter(:contracts_count, distributor_id)
    end
  end
  
  def self.valid_count(contract_ids = nil)
    unless contract_ids.blank?
      if contract_ids.is_a?(Array)
        Distributor::Shop.count("id", :conditions => ["id in (?)", contract_ids])
      end
    else
      Distributor::Shop.count("id")
    end
  end
end
