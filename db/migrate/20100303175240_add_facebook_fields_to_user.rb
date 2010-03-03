class AddFacebookFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_id, :integer, :limit=>8
    add_column :users, :session_key, :string
  end

  def self.down
  end
end
