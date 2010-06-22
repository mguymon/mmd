class App < ActiveRecord::Base
    set_table_name "applications"

    belongs_to :project
    has_many :environments
    has_many :accesses, :as => :accessable
end