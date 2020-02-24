require 'bunny'
require 'net/http'

require 'spectre/version'
require 'spectre/http/client'
require 'spectre/http/errors'
require 'spectre/http/request'
require 'spectre/amqp/connection'
require 'spectre/amqp/message'
require 'spectre/amqp/errors'
require 'spectre/amqp/client'

module Spectre

  class << self

    def amqp_configuration
      @amqp_configuration
    end

    def amqp_configuration=(config)
      @amqp_configuration = config
    end

  end

end
