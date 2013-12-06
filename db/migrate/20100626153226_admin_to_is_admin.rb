class AdminToIsAdmin < ActiveRecord::Migration
  def self.up
    rename_column :users, :admin, :is_admin
  end

  def self.down
    rename_column :users, :is_admin, :admin
  end
end
