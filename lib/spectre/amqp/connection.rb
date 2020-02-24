require 'spectre/amqp/errors'

module Spectre
  module Amqp
    class Connection
      @instance = nil

      attr_accessor :singleton_connection, :singleton_mutex, :configuration

      class << self
        def connection
          @instance = new unless instance.present?
          establish! unless instance.connected?
          instance.singleton_connection
        end

        def establish!
          if instance.blank?
            @instance = new
          elsif instance.present? && !instance.connected?
            instance.singleton_connection.close
            @instance = new
          end
        end
      end

      def connected?
        singleton_mutex.synchronize do
          singleton_connection.present? && singleton_connection.connected?
        end
      end

      private

      def initialize
        self.singleton_mutex = Mutex.new
        connect!
        at_exit { close_connection }
      end

      def connect!
        singleton_mutex.synchronize do
          set_connection
        end
      end

      def set_connection
        config = Spectre.amqp_configuration
        raise InvalidConfigurationError, 'Invalid Rabbit MQ configuration' if !config.is_a?(Hash) || config.empty?
        self.singleton_connection = Bunny.new(config).tap(&:start)
      end

      def close_connection
        singleton_connection.close
      end

      def self.instance
        @instance
      end
    end

  end
end