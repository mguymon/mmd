class Project < ActiveRecord::Base
    belongs_to :client
    has_many :apps
    has_many :accesses, :as => :accessable

    validates_uniqueness_of :name, :scope => :client_id
    validates_uniqueness_of :short_name, :scope => :client_id
end