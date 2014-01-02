class CreateUserPlans < ActiveRecord::Migration
  def change
    create_table :user_plans do |t|
      t.integer :user_id, :null => false
      t.integer :plan_id, :null => false
      t.timestamps
    end

    add_index :user_plans, [:plan_id, :user_id]
  end
end
