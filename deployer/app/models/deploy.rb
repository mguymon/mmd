class Deploy < ActiveRecord::Base
    belongs_to :environment
    has_one :deploy_process
end