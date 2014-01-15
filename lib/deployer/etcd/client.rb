require 'deployer/etcd'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module Deployer
  class Etcd::Client

    def defaults
      {prefix: '/v2/keys', raw: false}
    end

    def self.connect(url=nil)
      url = ENV['MMD_ETCD'] if url.nil?

      ssl_opts = {
          client_cert: ENV['MMD_CLIENT_CERT'],
          client_key: ENV['MMD_CLIENT_KEY'],
          ca_file: ENV['MMD_CA_CERT']
      }

      connection = Faraday.new(:url => url, ssl: ssl_opts) do |faraday|
        faraday.adapter :typhoeus
      end

      self.new(connection)
    end

    def initialize(connection)
      @connection = connection
    end

    def get(path, opts = {})
      options = defaults.merge opts
      response = @connection.get build_url(path, options)
      val = nil
      if options[:raw]
        val = response.body
      else
        result = JSON.parse(response.body)
        if result['node'] && result['node']['value']
          val = result['node']['value']
        end
      end

      val
    end

    def put(path, value, opts={})
      options = defaults.merge opts
      payload = {value: value}
      response = @connection.put build_url(path, options), payload
      if options[:raw]
        response.body
      else
        JSON.parse response.body
      end
    end

    def list(path, opts={})
      options = defaults.merge opts

      path << '?recursive=true' if options[:recursive]

      # Use get to fetch the raw json for the listing
      response = get(path, options.merge(raw: true))

      val = nil
      if options[:raw]
        val = response
      else
        result = JSON.parse(response)
        if result['node'] && result['node']['nodes']
          val = result['node']['nodes'].map do |node|
            flatten_listing(node)
          end
        end
      end

      val
    end

    private
    def build_url(path, opts)
      "#{opts[:prefix]}#{path}"
    end

    def flatten_listing(node)
      if node
        if node['dir']
          listing = node['nodes'].map { |node| flatten_listing(node) }
          { File.basename(node['key']) => listing }
        else
          { File.basename(node['key']) => node['value'] }
        end
      end
    end
  end
end