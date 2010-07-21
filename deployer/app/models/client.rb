class Client < ActiveRecord::Base
  has_many :projects
  has_many :accesses, :as => :accessable

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :short_name
  validates_uniqueness_of :short_name

  before_save :cleanup_short_name

  def cleanup_short_name
    if self.short_name
      self.short_name = self.short_name.downcase.strip
    end
  end
end