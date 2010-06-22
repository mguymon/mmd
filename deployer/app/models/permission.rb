class Permission < ActiveRecord::Base
    has_many :accesses
end