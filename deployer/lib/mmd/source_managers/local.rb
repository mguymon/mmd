require 'fileutils'
require 'mmd/required_params'

module MMD
  module SourceManagers
    class Local
      include MMD::RequiredParams
      
      def initialize( params )
        required_params( params, [ 'local_path', 'checkout_path' ] )
        set_instance_variables( params )
      end

      def repository
        @local_path
      end

      def checkout
        @logger.debug( "local path: #{@local_path}")
        @logger.debug( "checkout path: #{@checkout_path}")
        if @local_path != @checkout_path
          FileUtils.mkdir( @checkout_path ) unless File.exists?( @checkout_path )
          FileUtils.cp_r( "#{@local_path}/.", @checkout_path )
        else
          @logger.info( "Local and Deploy path are the same, #{@checkout_path}" )
        end
      end
    end
  end
end