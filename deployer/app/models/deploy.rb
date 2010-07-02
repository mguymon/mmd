class Deploy < ActiveRecord::Base
    belongs_to :environment
    belongs_to :deployed_by, :class_name => 'Account', :foreign_key => 'deploy_by_id'
    has_one :deploy_process

end