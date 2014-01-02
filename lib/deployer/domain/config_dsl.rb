module Deployer
  class Domain::ConfigDsl

    attr_reader :deploy

    def intialize(plan, deploy)
      @plan = plan
      @deploy = deploy
      @config = {'namespace' => @plan.namespace}
    end

    def set(key, val)
      @config[key.to_s] = val

      self
    end

    def inject(&blk)
      dsl = ConfigInjectDsl.new(@deploy)
      dsl.instance_eval(&blk) if blk
      @config.merge( dsl.to_hash )

      dsl
    end

    def to_hash
      @config
    end
  end
end