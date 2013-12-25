class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploys do |t|
      t.references :deployable, :null => false, :polymorphic => true
      t.datetime :completed_at
      t.timestamps
    end

    add_index :deploys, [ :deployable_type, :deployable_id ], :unique => true
  end
end
