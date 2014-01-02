class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :user_plans
  has_many :plans, through: :user_plans

  has_many :user_accounts
  has_many :accounts, through: :user_accounts

  def full_name
    "#{first_name} #{last_name}"
  end
end
