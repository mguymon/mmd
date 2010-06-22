class Group < ActiveRecord::Base
    has_many :accesses, :foreign_key => 'accessor_id', :conditions => "accessor_type = 'Group'"
end