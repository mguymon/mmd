class Deployer::AssetHelper
  include ActionView::Helpers::JavaScriptHelper

  def self.escape_javascript( text )
    @instance ||= self.new
    return @instance.escape_javascript( text )
  end
end