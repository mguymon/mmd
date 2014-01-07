require 'deployer/etcd/client'

module EtcdHelpers

  def mock_connection(&blk)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.instance_eval(&blk)
      end
    end
  end
end