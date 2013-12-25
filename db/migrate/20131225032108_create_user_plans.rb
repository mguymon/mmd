class CreateUserPlans < ActiveRecord::Migration
  def change
    create_table :user_plans do |t|
      t.integer :user_id
      t.integer :plan_id
      t.timestamps
    end

    add_index :user_plans, [:user_id, :plan_id]
  end
end
