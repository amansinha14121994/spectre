require 'spectre/amqp/errors'

module Spectre
  module Amqp
    class Message

      DEFAULT_CONTENT_TYPE = 'application/json'
      EXCHANGE_TYPES = {
          topic: :topic,
          fanout: :fanout,
          direct: :direct,
          headers: :headers
      }.freeze

      def initialize(message, exchange_type, options = {})
        validate(exchange_type)
        @message = message
        @exchange_type = exchange_type
        @routing_key = options[:routing_key]
        @exchange = options[:exchange]
        @headers = options[:headers] || {}
        @content_type = options[:content_type] || DEFAULT_CONTENT_TYPE
      end

      def publish
        p "Spectre Message Object - #{self.inspect}"
        p "Spectre Connection Object - #{self.connection.inspect}"
        with_channel do |channel|
          exchange = Bunny::Exchange.new(channel, @exchange_type, @exchange, durable: true)
          exchange.publish(@message, routing_key: @routing_key, content_type: @content_type, headers: @headers)
        end
      end

      def with_channel
        channel = connection.create_channel
        message = yield channel
        channel.close
        message
      end

      def connection
        Spectre::Amqp::Connection.connection
      end

      private

      def validate(exchange_type)
        raise InvalidExchangeType, "Invalid MQ Exchange type #{exchange_type}" unless exchange_type.present? && EXCHANGE_TYPES.key?(exchange_type.to_sym)
      end

    end
  end
end

