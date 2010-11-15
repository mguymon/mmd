class RemoveProjectUniqueConstraint < ActiveRecord::Migration
  def self.up
      remove_index :projects, :name
  end

  def self.down
  end
end
