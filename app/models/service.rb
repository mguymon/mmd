class Service < ActiveRecord::Base

  belongs_to :server
  delegate :name, :to => :server, :prefix => true
end
