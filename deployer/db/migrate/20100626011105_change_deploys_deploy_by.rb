class ChangeDeploysDeployBy < ActiveRecord::Migration
  def self.up
    remove_column :deploys, :deployed_by
    add_column :deploys, :deployed_by_id, :integer
  end

  def self.down
    remove_column :deploys, :deployed_by_id
    add_column :deploys, :deployed_by, :string
  end
end
