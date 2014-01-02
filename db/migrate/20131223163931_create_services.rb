class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name, :slug
      t.integer :plan_id, :server_id
      t.timestamps
    end
  end
end
