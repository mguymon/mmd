class Plan < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :scoped, :scope => [:account_id]

  has_settings do |s|
    s.key :config
  end

  belongs_to :account
  has_many :services
  has_many :user_plans
  has_many :users, through: :user_plans

  def namespace
    "/#{self.account.id}/#{self.name}"
  end
end
