class CreateMonitorRecords < ActiveRecord::Migration
  def self.up
    create_table :monitor_records do |t|
      t.boolean :completed
      t.integer :tweets_sent
      t.integer :overruns
      t.decimal :runtime

      t.timestamps
    end
  end

  def self.down
    drop_table :monitor_records
  end
end
