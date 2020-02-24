module Spectre
  module Http
    class Client

      attr_accessor :config

      CONFIG = Struct.new(:host)

      def initialize(options = {})
        self.config = CONFIG.new
        self.config.host = options[:host]
      end

      def get(endpoint, params = {}, headers = nil, options = {})
        request = Request.new(construct_request_url(endpoint), Request::GET, headers, options, params: params)
        request.perform
      end

      def post(endpoint, payload = {}, headers = nil, options = {})
        request = Request.new(construct_request_url(endpoint), Request::POST, headers, options, payload: payload)
        request.perform
      end

      def put(endpoint, payload = {}, headers = nil, options = {})
        request = Request.new(construct_request_url(endpoint), Request::PUT, headers, options, payload: payload)
        request.perform
      end

      def delete(endpoint, payload = {}, headers = nil, options = {})
        request = Request.new(construct_request_url(endpoint), Request::DELETE, headers, options, payload: payload)
        request.perform
      end

      def patch(endpoint, payload = {}, headers = nil, options = {})
        request = Request.new(construct_request_url(endpoint), Request::PATCH, headers, options, payload: payload)
        request.perform
      end

      private

      def construct_request_url(endpoint)

      end

    end
  end
end