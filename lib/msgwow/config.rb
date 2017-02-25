module Msgwow
  class Config

    # this can be overridden on a per-message basis
    attr_accessor :sender

    # The authkey of the Msgwow account to use when accessing the API
    attr_accessor :authkey

    attr_accessor :route

    def initialize
      @authkey = ENV['MSGWOW_AUTH_KEY']
      @route = 4
      @sender = 'MSGWOW'
    end
  end
end