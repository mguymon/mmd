class Environment < ActiveRecord::Base    
    belongs_to :app
    has_many :environment_parameters
    has_many :deploys
    has_many :accesses, :as => :accessable
    has_one :deploy_process

    def parameters
      if @parameters.nil?
          @parameters =
              Hash[*environment_parameters.collect { |param|
                [param.name.to_sym, param.value]
              }.flatten]
      end

      return @parameters
    end
end