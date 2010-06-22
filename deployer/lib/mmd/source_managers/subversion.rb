include_class "org.tmatesoft.svn.core.wc.ISVNOptions"
require 'subversion_util'
require 'mmd'
require 'mmd/required_params'
require 'fileutils'


module MMD
  module SourceManagers
    class Subversion
      include MMD::RequiredParams
      
      def initialize( params )
        params = {:scm_username => nil, :scm_password => nil }.merge( params )
        required_params( params, [ 'svn_url', 'svn_root', 'svn_path', 'checkout_path' ] )
        set_instance_variables( params )
        @subversion = SubversionUtil.new(@scm_username, @scm_password)
      end

      def repository
        "#{@svn_url}/#{@svn_root}/#{@svn_path}"
      end
            
      def checkout
        if @svn_url and @svn_root and @svn_path
          if File.exists?( @checkout_path )
            FileUtils.rm_r( @checkout_path )
          end

          @logger.info( "Creating checkout dir: #{@checkout_path}" )
          #Dir.mkdir( @checkout_path )

          @logger.info( "Exporting #{repository}")
          @subversion.export( repository,  @checkout_path, { :force => true} )
        else
          raise ActionError.new( "MMD::SourceManagers::Subversion checkoutfailed: svn url, root, and path are required" )
        end
      end
            
    end
  end
end