require 'net/http'
require 'uri'

module MMD
    module Actions
        module WebRequest
            attr_accessor :cookie, :url, :http, :requests
            def before_action
                @cookie = nil                                
                @url = URI.parse( @options[:url] )
                @http = Net::HTTP.new( @url.host, @url.port)
                if @url.scheme == 'https'
                  @http.use_ssl = true
                  # TODO: make verify mode a config option? production only?
                  @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                end
                @http.read_timeout = @options[:read_timeout]? @options[:read_timeout] : 300
                @requests = []                
            end

            def get( path, options={} )
                get = Net::HTTP::Get.new( path )
                if @cookie
                    get.initialize_http_header({ 'cookie' => @cookie })
                end                
                @requests << get
            end

            def post( path, options={ :params => {} } )
                post = Net::HTTP::Post.new( path )
                post.set_form_data( options[:params])
                if @cookie
                    post.initialize_http_header({ 'cookie' => @cookie })
                end
                @requests << post
            end

            def action
                responses = []
                @logger.info( "  accessing #{@url.to_s}")
                @http.start do |connection|
                    @requests.each do |request|
                        @logger.info( "  requesting #{request.path}")
                        begin
                          responses << connection.request(request)
                        rescue
                          @logger.error( "Failed to request #{@url.to_s}#{request.path}: #{$!}" )
                          raise WebRequestError.new( $! )
                        end
                        # TODO: check that request was successful
                        #@logger.info( response.body.gsub(/<.*?>/, '') )
                    end
                end
                responses
            end
        end

        class WebRequestError < RuntimeError
          
        end
    end
end

