module MMD
  module Template
    module Remote
      def self.extend(base)
        base.template_validation_chain = base.template_validation_chain || []
        base.template_validation_chain << :template_remote_validate
      end

      def template_remote_validate
        if parameters[:remote_host].nil?
          self.errors.add( :environment_parameters, "remote_host is required" )
        end

        if parameters[:remote_username].nil?
          self.errors.add( :environment_parameters, "remote_username is required" )
        end
        
      end
    end
  end
end