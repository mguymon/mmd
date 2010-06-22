class DeployProcess < ActiveRecord::Base
    has_one :environment
    belongs_to :deploy
end
