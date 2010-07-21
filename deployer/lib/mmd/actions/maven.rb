
module MMD
  module Actions
    module Maven

      def before_action()
        @goals = []
        @checkout_path = @parameters[:checkout_path]
      end

      def action
        @goals.each do |goal|
          `cd #{@checkout_path} && mvn -Dmaven.test.skip=true #{goal}`
        end
      end

      def goal( goal, opts = {} )

        @goals << goal
      end
    end
  end
end
