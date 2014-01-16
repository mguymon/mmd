require "test_helper"

class Deployer::Etcd::ClientTest < ActiveSupport::TestCase

end

describe Deployer::Etcd::ClientTest do
  describe "#get" do
    before do
      @json = json = '{"action":"get","node":{"key":"/foo","value":"bar","modifiedIndex":3,"createdIndex":3}}'
      connection = mock_connection do
        get('/v2/keys/foo') {[ 200, {}, json ]}
      end
      @client = Deployer::Etcd::Client.new( connection )
    end

    it 'will return a val' do
      assert_equal 'bar', @client.get('/foo')
    end

    it 'will return a raw response' do
      assert_equal @json, @client.get('/foo', raw: true)
    end
  end

  describe "#list" do

    before do
      @json = json = '{"action":"get","node":{"key":"/","dir":true,"nodes":[{"key":"/foo","value":"bar","modifiedIndex":3,"createdIndex":3},{"key":"/w00t","value":"rawr","modifiedIndex":4,"createdIndex":4}]}}'
      connection = mock_connection do
        get('/v2/keys/') {[ 200, {}, json ]}
      end
      @client = Deployer::Etcd::Client.new( connection )
    end

    it 'will return nodes' do
      assert_equal {"foo"=>"bar", "w00t"=>"rawr"}, @client.list('/')
    end

    it 'will return a raw response' do
      assert_equal @json, @client.list('/', raw: true)
    end
  end
end
