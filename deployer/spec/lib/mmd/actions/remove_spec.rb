require 'spec/spec_helper.rb'
require 'mmd'

describe MMD::Action do

    before(:each) do
        @spec = create_spec()
        @lifecycle = MMD::Lifecycle.new( 'test', @spec )
        @checkout_path = @spec.checkout_path

        FileUtils.mkdir_p( @checkout_path )
    end

    it "should remove a file" do
        file_name = File.join( @checkout_path, "remove_action_spec.test" )
        test_file = File.new( file_name, "w+")
        test_file.puts "here is something to write to the file"

        File.exist?( file_name ).should be_true
        @action = MMD::Action.new( :remove, @lifecycle.parameters ) do
            file "remove_action_spec.test"
        end
        @action.execute
        File.exist?( file_name ).should be_false
    end

    it "should remove all files" do
        file_name_1 = File.join( @checkout_path, "remove_action_spec1.test")
        file_name_2 = File.join( @checkout_path, "remove_action_spec2.test")
        file_name_3 = File.join( @checkout_path, "remove_action_spec3.test")
        test_file = File.new( file_name_1, "w+")
        test_file.puts "here is something to write to the file"
        test_file = File.new( file_name_2, "w+")
        test_file.puts "here is something to write to the file"
        test_file = File.new( file_name_3, "w+")
        test_file.puts "here is something to write to the file"

        File.exist?( file_name_1 ).should be_true
        File.exist?( file_name_2 ).should be_true
        File.exist?( file_name_3 ).should be_true
        @action = MMD::Action.new( :remove, @lifecycle.parameters ) do
            file "remove_action_spec?.test"
        end
        @action.execute
        File.exist?( file_name_1 ).should be_false
        File.exist?( file_name_2 ).should be_false
        File.exist?( file_name_3 ).should be_false
    end

    it "should remove an empty dir" do
        dir_name = File.join( @checkout_path, "remove_action_spec_test")
        if not File.exist? dir_name
          Dir.mkdir( dir_name )
        end

        File.exist?( dir_name ).should be_true
        @action = MMD::Action.new( :remove, @lifecycle.parameters ) do
            dir "remove_action_spec_test"
        end
        @action.execute
        File.exist?( dir_name ).should be_false
    end

    it "should only remove a dir with the empty_path_only is false" do
        dir_name = File.join( @checkout_path, "remove_action_spec_empty_path_test")
        if not File.exist? dir_name
          Dir.mkdir( dir_name )
          file_name = File.join( dir_name, "remove_action_spec.test" )
          test_file = File.new( file_name, "w+")
          test_file.puts "here is something to write to the file"
        end

        File.exist?( dir_name ).should be_true
        lambda {
            @action = MMD::Action.new( :remove, @lifecycle.parameters ) do
                dir "remove_action_spec_empty_path_test"
            end
            @action.execute
        }.should raise_error(ActionError)
        File.exist?( dir_name ).should be_true

        @action = MMD::Action.new( :remove, @lifecycle.parameters ) do
          dir "remove_action_spec_empty_path_test", :empty_dir_only => false
        end
        @action.execute
        File.exist?( dir_name ).should be_false
    end
end

