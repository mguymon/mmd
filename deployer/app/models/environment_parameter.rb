class EnvironmentParameter < ActiveRecord::Base
    belongs_to :environment
    validates_uniqueness_of :name, :scope => :environment_id

end