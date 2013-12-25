class Plan < ActiveRecord::Base
  has_settings do |s|
    s.key :config
  end

  has_many :services
  has_many :user_plans
  has_many :users, through: :user_plans
end
