module Spectre
  module Amqp
    class Client

      attr_reader :config

      CONFIG = Struct.new(:host, :port, :vhost, :user, :password)

      def initialize(mq_config = {})
        @config = CONFIG.new
        @config.host = mq_config[:host]
        @config.port = mq_config[:port]
        @config.vhost = mq_config[:vhost]
        @config.user = mq_config[:user]
        @config.password = mq_config[:password]
      end

      private

      def set_mq_connection
        Spectre.amqp_configuration = @config.to_h
        Spectre::Amqp::Connection.establish!
      end

    end
  end
end
