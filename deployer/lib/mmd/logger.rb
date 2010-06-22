require 'singleton'
require 'log4r'

module MMD
  class Logger
    include Log4r

    def self.for_log_file( name, log_file, log_level= :debug )
        logger = Log4r::Logger.new( name )

        # Log to stdout
        logger.outputters = Outputter.stdout

        if log_file
          # Open a new file logger
          file_output = FileOutputter.new('fileOutputter', :filename => log_file, :trunc => false)
          format = PatternFormatter.new(:pattern => "[%l] %d :: %m")
          file_output.formatter = format
          logger.add( file_output )
        end

        # DEBUG < INFO < WARN < ERROR < FATAL
        logger.level = eval( "Log4r::#{log_level.to_s.upcase}")
        logger
    end
    
  end
end