class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :slug
      t.timestamps
    end
  end
end
