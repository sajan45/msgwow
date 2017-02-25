require 'msgwow/version'
require 'msgwow/message'
require 'msgwow/config'

module Msgwow
  class << self

    def config
      @config ||= Config.new
      if block_given?
        yield @config
      end
      @config
    end

    def reset_config
      @config = nil
    end

    def send_message(message, numbers, options={})
      msg = Msgwow::Message.new(message, numbers, options)
      msg.send!
      msg
    end
  end
end
