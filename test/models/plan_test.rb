require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

describe Plan do
  include EtcdHelpers

  describe "instance" do
    let(:plan) { FactoryGirl.create(:plan) }

    before do
      connection = mock_connection do |stub|
        json = '{"action":"get","node":{"key":"/","dir":true,"nodes":[{"key":"/foo","value":"bar","modifiedIndex":3,"createdIndex":3},{"key":"/w00t","value":"rawr","modifiedIndex":4,"createdIndex":4}]}}'
        stub.get("/v2/keys/#{namespace}") {[ 200, {}, json ]}
      end

      plan.client_connection(connection)
    end

    it 'should have a config' do
      assert_equal( {"foo"=>"bar","w00t"=>"rawr"}, plan.config )
    end
  end
end