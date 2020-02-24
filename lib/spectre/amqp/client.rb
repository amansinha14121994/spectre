module Spectre
  module Amqp
    class Client

      CONFIG = Struct.new(:host, :vhost, :user, :password)

      def initialize(mq_config = {})
        @config = CONFIG.new
        @config.host = mq_config[:host]
        @config.user = mq_config[:user]
        @config.password = mq_config[:password]
      end

      private

      def set_connection
        Spectre.amqp_configuration = @config.to_h
        Spectre::Amqp::Connection.establish!
      end

    end
  end
end