class CreatePrintRecords < ActiveRecord::Migration
  def self.up
    create_table :print_records do |t|
      t.datetime :month
      t.integer :amount

    end
  end

  def self.down
    drop_table :print_records
  end
end
