require 'buildr/version'
require 'buildr/core'
require 'buildr/packaging'
require 'buildr/java'
require 'buildr/ide'
require 'buildr/shell'
require 'buildr/run'


module Buildr
  # Patch Buildr to allow tasks to be set manually
  class Application

    attr_accessor :rakefile, :top_level_tasks, :location

    # disable collect_tasks which loads tasks from command line
    def collect_tasks

    end

    # allow buildfile and location to be manually set
    def find_buildfile
      unless @buildfile.nil? && @location.nil?
        buildfile, @location = find_rakefile_location || (tty_output? && ask_generate_buildfile)
        fail "No Buildfile found (looking for: #{@rakefiles.join(', ')})" if buildfile.nil?
        @rakefile = buildfile
      end
      Dir.chdir(@location)
    end
  end
end


module MMD
  module Actions
    module BuildrAction
      def before_action()
        @tasks = []

        if @options[:buildfile]
          @buildfile = @options[:buildfile]
        else
          @buildfile = 'buildfile'
        end
      end

      def action
        if @tasks.size > 0
          buildr = Buildr::Application.new

          buildr.rakefile = @buildfile
          buildr.location = @checkout_path
          buildr.top_level_tasks = @tasks
          buildr.run
        end
      end

      def task( task )
        @tasks << task.to_s
      end
    end
  end
end
