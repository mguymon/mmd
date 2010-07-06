class Project < ActiveRecord::Base
  belongs_to :client
  has_many :apps
  has_many :accesses, :as => :accessable

  validates_uniqueness_of :name, :scope => :client_id
  validates_uniqueness_of :short_name, :scope => :client_id

  before_save :cleanup_short_name

  def cleanup_short_name
    if self.short_name
      self.short_name = self.short_name.downcase.strip
    end
  end
end