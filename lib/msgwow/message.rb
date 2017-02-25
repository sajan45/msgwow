require 'net/https'
require 'uri'
require 'json'
require 'cgi'

module Msgwow
  class Message

    attr_accessor :message
    attr_accessor :mobiles
    attr_accessor :sender
    attr_accessor :route
    attr_accessor :response

    SMS_ENDPOINT = URI.parse("http://my.msgwow.com/api/sendhttp.php?response=json")

    def initialize(message=nil, mobiles=nil, options=nil)
      self.message = message if message
      self.mobiles = mobiles if mobiles
      self.options = options if options
    end

    def message=(message)
      @message = CGI.escape(message)
    end

    def mobiles
      @mobiles ||= []
    end

    def mobiles=(mobiles)
      @mobiles = []
      if mobiles.is_a?Array
        mobiles.map!(&:to_s)
      else
        mobiles = mobiles.to_s.split(',')
      end
      mobiles.each do |num|
        add_recipient(num)
      end
    end

    def add_recipient(number)
      number = number.gsub(/\s/, '')
      number = case number
        when /^91\d{10}$/
          number
        when /^(?:\+91)(\d{10})$/
          "91#{$1}"
        when /^(\d{10})$/
          "91#{$1}"
        else
          return
      end
      @mobiles << number
    end

    def sender
      self.sender = Msgwow.config.sender unless @sender
      @sender
    end

    def sender=(sender)
      @sender = sender.strip.gsub(/[^\w]/, '').to_s[0, 6] if sender
      if @sender && @sender.length != 6
        @sender = nil
      end
    end

    def route
      self.route = Msgwow.config.route unless @route
      @route
    end

    def route=(new_route)
      @route = new_route if new_route
    end

    def options=(options)
      self.sender = options[:sender] if options.has_key?(:sender)
      if options.has_key?(:route) and [1,4].include? options[:route]
        self.route = options[:route]
      end
    end

    def response=(response)
      unless response.body.empty?
        @response = {}
        if response.body.is_a? String
          @response['body'] = response.body
        else
          data = JSON.parse(response.body)
          data.each_pair do |k, v|
            key = k.gsub(/\B[A-Z]+/, '_\0').downcase.to_sym
            @response[key] = v
          end
        end
      end
    end

    def send!
      http = Net::HTTP.new(SMS_ENDPOINT.host, SMS_ENDPOINT.port)
      http.use_ssl = false
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(SMS_ENDPOINT.path)
      params = {
                'authkey' => Msgwow.config.authkey,
                'mobiles' => mobiles.join(','),
                'message' => self.message,
                'route'   => route,
                'sender'  => sender
               }
      req.set_form_data(params)
      result = http.start { |http| http.request(req) }
      self.response = result
      return 'test'
    end
  end
end