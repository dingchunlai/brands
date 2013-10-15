class CreateCouponFaqs < ActiveRecord::Migration
  def self.up
    create_table :coupon_faqs do |t|
      t.string :question
      t.string :answer, :limit => 500
      t.boolean :deleted, :default => false
      t.integer :faq_group_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :coupon_faqs
  end
end
