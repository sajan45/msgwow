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

    def send_flash_message(message, numbers, options={})
      options.merge!(flash: 1)
      self.send_message(message, numbers, options)
    end

    def send_unicode_message(message, numbers, options={})
      options.merge!(unicode: 1)
      self.send_message(message, numbers, options)
    end

  end
end
