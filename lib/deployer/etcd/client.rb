module Deployer
  class Etcd::Client

  	def defaults
		  {prefix:'/v2/keys', raw: false}
  	end

  	def self.connection(url)
  		ssl_opts = {
          client_cert: ENV['MMD_CLIENT_CERT'],
          client_key: ENV['MMD_CLIENT_KEY'],
          ca_file: ENV['MMD_CA_CERT']
      	}

  		@connection = Faraday.new(:url => url, ssl: ssl_opts) do |faraday|
        	faraday.adapter Faraday::Adapter::Typhoeus
      	end

      	self
  	end

  	def get( path, opts = {} )
  	  options = defaults.merge opts
	    response = @connection.get build_url(path, options)
      val = nil
      if options[:raw]
      	val = result
      else
        result = JSON.parse(response.body)
        if result['node'] && result['node']['value']
          val = result['node']['value']
        end
      end


      val
  	end

  	def put( path, value, opts)
  		options = defaults.merge opts
  		payload = {value: value}
  		response = @connection.put build_url(path, options), payload
      if options[:raw]
        response.body
      else
  		  JSON.parse response
      end
  	end

  	def list( path, value, opts )
  		options = defaults.merge opts

  		# Use get to fetch the raw json for the listing
  		response = get(path, value, options.merge(raw: true) )

      val = nil
  		if options[:raw]
	      val = result
      else
        result = JSON.parse(response.body)
        # XXX: pluck the keys out of the response

        val = result # XXX: placeholder
      end

      val
  	end

    private
    def build_url(path, opts)
      "#{opts[:prefix]}#{path}"
    end
  end
end