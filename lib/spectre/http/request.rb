require 'net/http'

module Spectre
  module Http
    class Request

      attr_accessor :uri, :headers, :body, :method, :options

      DEFAULT_OPEN_TIMEOUT = 3.freeze
      DEFAULT_READ_TIMEOUT = 3.freeze
      VALID_REQUEST_METHODS = %i[get post put patch delete].freeze
      GET = :get
      POST = :post
      DELETE = :delete
      PUT = :put
      PATCH = :patch
      RESPONSE = Struct.new(:body, :code)

      def initialize(url, request_method,	request_headers, request_body, request_options)
        self.uri = URI(url)
        self.method = request_method
        self.headers = request_headers || {}
        self.body = request_body
        self.options = request_options || {}
      end

      def perform
        validate_request_method
        construct_request_options
        construct_headers
        request_class = Kernel.const_get("Net::HTTP::#{self.method.to_s.capitalize}")
        request = request_class.new(self.uri.path, self.headers)
        request.body = self.body.to_json unless self.body.nil?
        begin
          http_response = Net::HTTP.start(self.uri.host, self.uri.port, self.options) do |http|
            http.request(request)
          end
          response = RESPONSE.new
          response.body = JSON.parse(http_response.body, symbolize_names: true)
          response.code = http_response.code.to_i
        rescue => e
          response = error_response(e)
        end
        response
      end

      def error_response(error)
        res = RESPONSE.new(:body, :code)
        res.body = { message: "Something went wrong! #{error.message}" }
        res.code = 500
        res
      end

      def construct_request_options
        self.options[:read_timeout] ||= DEFAULT_OPEN_TIMEOUT
        self.options[:open_timeout] ||= DEFAULT_OPEN_TIMEOUT
        if self.uri.scheme == "https"
          self.options[:use_ssl] = true
          self.options[:verify_mode] = OpenSSL::SSL::VERIFY_NONE
        end
      end

      def construct_headers
        self.headers
      end

      def validate_request_method
        unless VALID_REQUEST_METHODS.include?(self.method.to_sym)
          raise InvalidRequestMethodError.new("The request method #{self.method} is invalid!")
        end
      end

    end
  end
end