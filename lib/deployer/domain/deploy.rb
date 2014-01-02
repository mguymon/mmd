module Deployer
  class Domain::Deploy
    attr_reader :config
    attr_reader :devopts
    attr_reader :plan

    def initialize(plan)
      @plan = plan
      @config  = OpenStruct.new
      @devopts = OpenStruct.new( 'servers' => {} )
    end
  end
end