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
        ant_call = AntCall.new( File.join( @checkout_path, build_xml ) )
        @tasks.each do |task|
          ant_call.run_task( task )
        end
      end

      def task( task )
        @tasks << task
      end
    end
  end
end
