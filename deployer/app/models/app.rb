class App < ActiveRecord::Base
  set_table_name "applications"

  belongs_to :project
  has_many :environments
  has_many :accesses, :as => :accessable

  validates_uniqueness_of :name, :scope => :project_id
  validates_uniqueness_of :short_name, :scope => :project_id

  before_save :cleanup_short_name

  def cleanup_short_name
    if self.short_name
      self.short_name = self.short_name.downcase.strip
    end
  end
end