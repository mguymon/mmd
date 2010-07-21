
module MMD
  module Actions
    module Maven

      def before_action()
        @goals = []
        @checkout_path = @parameters[:checkout_path]
      end

      def action
        @goals.each do |goal|
          IO.popen( "cd #{@checkout_path} && mvn -Dmaven.test.skip=true #{goal}" ) do |pipe|
            pipe.sync = true
            while msg = pipe.gets
                @logger.info( "  #{msg.strip()}" )
            end
          end
        end
      end

      def goal( goal, opts = {} )

        @goals << goal
      end
    end
  end
end
