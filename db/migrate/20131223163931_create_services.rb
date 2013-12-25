class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :plan_id
      t.timestamps
    end
  end
end
