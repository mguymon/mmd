class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :account_id
      t.string :name
      t.string :slug
      t.timestamps
    end

    add_index :plans, [:account_id, :slug], :unique => true
    add_index :plans, [:account_id, :name], :unique => true
  end
end
