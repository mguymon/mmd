class RemoveShortNameFromEnvironments < ActiveRecord::Migration
  def self.up
    remove_column( :environments, :short_name )
  end

  def self.down
    add_column( :environments, :short_name, :string )
  end
end
