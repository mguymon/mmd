include_class "powerplant.AntCall"

module MMD
  module Actions
    module Ant
      attr_accessor :build_xml

      def before_action()
        @tasks = []

        if @options[:build_xml]
          @build_xml = @options[:build_xml]
        else
          @build_xml = 'build.xml'
        end
      end

      def action
        ant_call = AntCall.new( @checkout_path, File.join( @checkout_path, build_xml ) )
        @tasks.each do |task|
          @logger.info( "Running ant task: #{task}")
          ant_call.run_task( task )
        end
      end

      def task( task )
        @tasks << task
      end
    end
  end
end
