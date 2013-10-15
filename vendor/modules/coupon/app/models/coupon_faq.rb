class CouponFaq < ActiveRecord::Base

  belongs_to :faq_group
  validates_presence_of :question, :answer

  default_scope :conditions => { :deleted => false }, :order => "created_at"

  named_scope :with_question, lambda { |quest| {
      :conditions => (quest.blank? ? nil : ['question LIKE ?', "%#{quest}%"])
    }
  }

  named_scope :with_group, lambda { |group_id| {
      :conditions => (group_id.to_i == 0 ? nil : ['faq_group_id = ?', group_id])
    }
  }

  def hide
    update_attribute :deleted, true
  end

end
