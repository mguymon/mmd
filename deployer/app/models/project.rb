class Project < ActiveRecord::Base
    belongs_to :client
    has_many :apps
    has_many :accesses, :as => :accessable
end