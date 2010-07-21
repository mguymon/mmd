class EnvironmentTemplate < ActiveRecord::Base
    belongs_to :environment
    validates_uniqueness_of :name
    validates_uniqueness_of :include

end