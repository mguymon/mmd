module Deployer
  class Domain::StorageDsl
    attr_reader :deploy

    def intialize(deploy)
      @deploy = deploy
      @connection = Fog::Storage.new({
          :provider                 => 'AWS',
          :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID'],
          :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY']
      })
      @directory = connection.directories.get( ENV['S3_BUCKET'] )
    end

    def contains?(key)
      !@directory.files.head(key).nil?
    end

    def [](key)
      @directory.files.get(key)
    end

  end
end