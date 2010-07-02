class App < ActiveRecord::Base
    set_table_name "applications"

    belongs_to :project
    has_many :environments
    has_many :accesses, :as => :accessable

    validates_uniqueness_of :name, :scope => :project_id
    validates_uniqueness_of :short_name, :scope => :project_id
end