class Access < ActiveRecord::Base
    belongs_to :accessable, :polymorphic => true
    belongs_to :account, :foreign_key => "accessor_id", :conditions => "accessor_type = 'Account'"
    belongs_to :group, :foreign_key => "accessor_id", :conditions => "accessor_type = 'Group'"
    belongs_to :permission
end