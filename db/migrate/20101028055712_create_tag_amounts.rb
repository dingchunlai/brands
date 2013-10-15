class CreateTagAmounts < ActiveRecord::Migration
  def self.up
    create_table :tag_amounts do |t|
      t.integer :tag_id
      t.integer :amount
      t.integer :print_record_id

    end
  end

  def self.down
    drop_table :tag_amounts
  end
end
