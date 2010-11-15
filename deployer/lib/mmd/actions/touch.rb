require 'fileutils'

module MMD
  module Actions
    module Touch
      def before_action()
        @file = File.join( @checkout_path, @options[:file] )
      end

      def action()
        FileUtils.touch @file
      end

    end
  end
end