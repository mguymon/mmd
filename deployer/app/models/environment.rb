class Environment < ActiveRecord::Base    
  belongs_to :app

  has_many :environment_parameters
  has_many :environment_templates
  has_many :deploys
  has_many :accesses, :as => :accessable

  has_one :deploy_process

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :app_id
  validates_presence_of :deployment_mode

  attr_accessor :template_validation_chain

  def parameters
    if @parameters.nil?
      @parameters =
        Hash[*environment_parameters.collect { |param|
          [param.name.to_sym, param.value]
        }.flatten]
    end

    return @parameters
  end

  def validate_parameters
    environment_templates.each do |template|
      if template =~ /^MMD::Template::[a-zA-Z0-9]+$/
        self.extend eval(template.include)
      end
    end

    if @template_validation_chain
      @template_validation_chain.each do |validation_method|
        self.send(validation_method)
      end
    end
  end

end