require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Actions::UpdateFile do

    before(:each) do
        @spec = create_spec()
        @lifecycle = MMD::Lifecycle.new( 'test', @spec )
        @checkout_path = @spec.checkout_path
        FileUtils.mkdir_p( @checkout_path )
    end

    it "should match and replace in file" do
        file_name = File.join( @checkout_path, "update_file_replace.test" )
        test_file = File.new( file_name, "w+")
        test_file.puts "here is something to write to the file"
        test_file.close

        @action = MMD::Action.new( :update_file, @lifecycle.parameters ) do
            replace "update_file_replace.test", /something/, "w00t"
        end
        @action.execute
        File.exist?( file_name ).should be_true

        File.readlines( file_name ).join.strip.should eql( "here is w00t to write to the file" )
        File.delete( file_name )
    end

    it "should match and replace then move file" do
        file_name = File.join( @checkout_path, "update_file_replace.test" )
        test_file = File.new( file_name, "w+")
        test_file.puts "here is something to write to the file"
        test_file.close

        file_name_dest = File.join( @checkout_path, "update_file_moved.test" )

        @action = MMD::Action.new( :update_file, @lifecycle.parameters ) do
            replace "update_file_replace.test", /something/, "w00t", :destination => "update_file_moved.test"
        end
        @action.execute
        File.exist?( file_name ).should be_false
        File.exist?( file_name_dest ).should be_true

        File.readlines( file_name_dest ).join.strip.should eql( "here is w00t to write to the file" )
        File.delete( file_name_dest )
    end

    it "should expand tokens in file" do
        file_name = File.join( @checkout_path, "update_file_token.test" )
        test_file = File.new( file_name, "w+")
        test_file.puts "a frog goes %TOKEN% and a dog goes %ANOTHER_TOKEN%"
        test_file.close
        @action = MMD::Action.new( :update_file, @lifecycle.parameters ) do
            expand_tokens "update_file_token.test", :tokens => { :token => "ribbit", :ANOTHER_TOKEN => 'woof'}
        end
        @action.execute
        File.readlines( file_name ).join.strip.should eql( "a frog goes ribbit and a dog goes woof" )
        File.delete( file_name )
    end

    it "should move file" do
        file_name = File.join( @checkout_path, "update_file_move.test" )
        test_file = File.new( file_name, "w+")
        test_file.puts "here is something to write to the file"
        test_file.close
        File.exist?( file_name ).should be_true
        file_name_dest = File.join( @checkout_path, "update_file_moved.test" )

        @action = MMD::Action.new( :update_file, @lifecycle.parameters ) do
            move "update_file_move.test", "update_file_moved.test"
        end
        @action.execute
        File.exist?( file_name ).should be_false
        File.exist?( file_name_dest ).should be_true
        
        File.delete( file_name_dest )
    end
end

