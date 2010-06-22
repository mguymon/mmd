module MMD
  module Actions
    module Logger
      def before_action()
        if @options[:level]
          @level = @options[:level].to_sym
        else
          @level = :info
        end

        @message = @options[:message]
      end

      def action()
        @logger.send(@level, @message)
      end
    end
  end
end