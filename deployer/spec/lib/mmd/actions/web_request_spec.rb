require 'spec/spec_helper.rb'
require 'net/http'
require 'uri'
require 'mmd'

describe MMD::Actions::WebRequest do

    before(:each) do
        @spec = create_spec()
        @lifecycle = MMD::Lifecycle.new( 'test', @spec )
    end

    it "should send get request" do
        path = 'a/path/to/get'
        @mock_http = mock("http")
        Net::HTTP.should_receive(:new).twice.with( "test.test.net", 80 ).and_return(@mock_http)
        @mock_http.should_receive(:read_timeout=).twice.with(300)

        @mock_get = mock("get")
        Net::HTTP::Get.should_receive(:new).with( path ).and_return(@mock_get)
        @mock_get.should_receive( :path ).twice.and_return( path )

        @mock_http.should_receive( :start ).twice.and_yield( @mock_http )
        @mock_http.should_receive(:request).twice.with( anything() )

        @action = MMD::Action.new( :web_request, @lifecycle.parameters, :url => 'http://test.test.net' ) do
            before_action
            get path
            action
        end
        @action.execute
    end

    it "should send post request" do
        path = 'a/path/to/get'
        @mock_http = mock("http")
        Net::HTTP.should_receive(:new).twice.with( "test.test.net", 443 ).and_return(@mock_http)
        @mock_http.should_receive(:use_ssl=).twice.with( true )
        @mock_http.should_receive(:verify_mode=).twice.with( 0 )
        @mock_http.should_receive(:read_timeout=).twice.with(300)

        @mock_post = mock("post")
        Net::HTTP::Post.should_receive(:new).with( path ).and_return(@mock_post)
        @mock_post.should_receive( :set_form_data ).with( {} )
        @mock_post.should_receive( :path ).twice.and_return( path )

        @mock_http.should_receive( :start ).twice.and_yield( @mock_http )
        @mock_http.should_receive(:request).twice.with( anything() )

        @action = MMD::Action.new( :web_request, @lifecycle.parameters, :url => 'https://test.test.net' ) do
            before_action
            post path
            action
        end
        @action.execute
    end
end

