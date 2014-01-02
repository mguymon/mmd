# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

connection = Fog::Storage.new({
    :provider                 => 'AWS',
    :aws_access_key_id        => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key    => ENV['AWS_SECRET_ACCESS_KEY']
})
directory = connection.directories.get( ENV['S3_BUCKET'] )

if directory.files.head('/certs/etcd.key').nil?
  directory.files.create(
      :key    => '/certs/etcd.key',
      :body   => File.open(ENV['MMD_CLIENT_KEY']),
      :public => false
  )
end

if directory.files.head('/certs/etcd.crt').nil?
  directory.files.create(
      :key    => '/certs/etcd.crt',
      :body   => File.open(ENV['MMD_CLIENT_KEY']),
      :public => false
  )
end

if directory.files.head('/certs/mmdca.crt').nil?
  directory.files.create(
      :key    => '/certs/mmdca.crt',
      :body   => File.open(ENV['MMD_CA_CERT']),
      :public => false
  )
end