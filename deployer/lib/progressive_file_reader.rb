
class ProgressiveFileReader
    attr_reader :start_pos, :end_pos, :output, :file_path
    
    def initialize( file_path )
      @file_path = file_path
      @output = ""
      @end_pos
    end
    
    def read(start_pos=0)
        @start_pos = start_pos        
        begin
            file = File.new( @file_path, "r")
            file.seek( @start_pos, IO::SEEK_SET)
            file.read( nil, @output )
            @end_pos = file.pos
            file.close
            return @output
        rescue => err
            puts "Exception: #{err}"
            err
        end
    end
end
