class AddTemplatesToEnvironment < ActiveRecord::Migration
  def self.up
    create_table "environment_templates" do |t|
      t.string "name", "include"
      t.integer "environment_id"
    end
  end

  def self.down
    drop_table "environment_templates"
  end
end
