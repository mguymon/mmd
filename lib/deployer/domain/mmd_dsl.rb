module Deployer
  class Domain::MmdDsl

    attr_reader :deploy

    def intialize(plan)
      @plan = plan.clone.freeze
      @deploy = Deployer::Domain::Deploy.new(@plan)
    end

    def config
      dsl = ConfigDsl.new(@plan, @deploy)
      dsl.instance_eval(&blk) if blk
      dsl.to_hash.each do |key,val|
        @deploy.config[key] = val
      end

      dsl
    end

    def server(&blk)
      dsl = ServerDsl.new(@plan)
      dsl.instance_eval(&blk) if blk
      dsl
    end

    def storage(&blk)
      dsl = StorageDsl.new(@plan)
      dsl.instance_eval(&blk) if blk
      dsl
    end

    def load_balancer(&blk)

    end

    def notifications(&blk)

    end
  end
end