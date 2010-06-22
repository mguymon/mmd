require 'ostruct'

module MMD
  config = {}
  YAML.load(File.open("#{RAILS_ROOT}/config/deploy.yml"))[ RAILS_ENV ].collect do |key,value|
    config[key] = ERB.new( value.to_s ).result
  end
  Option = OpenStruct.new(config)
end