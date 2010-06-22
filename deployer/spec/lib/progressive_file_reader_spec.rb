require 'spec/spec_helper.rb'
require 'progressive_file_reader'

describe ProgressiveFileReader do
    before(:each) do
        @test_file = File.expand_path(File.dirname(__FILE__) + "/../test.txt")
        file = File.new( @test_file )
        @test_output = ""
        file.read( nil, @test_output )
        file.close
        @progressive_file_reader = ProgressiveFileReader.new( @test_file )
    end

    it "should read entire file" do
        @progressive_file_reader.read().should eql( @test_output )
        @progressive_file_reader.start_pos.should eql( 0 )
        @progressive_file_reader.end_pos.should eql( @test_output.size )
        @progressive_file_reader.file_path.should eql( @test_file )
    end
    
    it "should read file from position 5" do
        @progressive_file_reader.read( 5 ).should eql( @test_output[5,@test_output.size] )
        @progressive_file_reader.start_pos.should eql( 5 )
        @progressive_file_reader.end_pos.should eql( @test_output.size )
        @progressive_file_reader.file_path.should eql( @test_file )
    end
end

