class Client < ActiveRecord::Base
    has_many :projects
    has_many :accesses, :as => :accessable

    validates_uniqueness_of :name
    validates_uniqueness_of :short_name
end