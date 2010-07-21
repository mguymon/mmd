module MMD
  module Template
    module Subversion
      def self.extend(base)
        base.template_validation_chain = base.template_validation_chain || []
        base.template_validation_chain << :template_subversion_validate
      end

      def template_subversion_validate
        if parameters[:scm_username] && parameters[:scm_password].nil?
          self.errors.add( :environment_parameters, "scm_username is set, scm_password is required")
        end

        if parameters[:scm_username].nil? && parameters[:scm_password]
          self.errors.add( :environment_parameters, "scm_password is set, scm_username is required")
        end

        if parameters[:scm] != 'subversion'
          self.errors.add( :environment_parameters, "scm should be set to subversion" )
        end

        if parameters[:svn_url].nil?
          self.errors.add( :environment_parameters, "svn_url is required" )
        end

        if parameters[:svn_path].nil?
          self.errors.add( :environment_parameters, "svn_path is required" )
        end

        if parameters[:svn_root].nil?
          self.errors.add( :environment_parameters, "svn_root is required" )
        end
        
      end
    end
  end
end