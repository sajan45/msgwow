require 'net/https'
require 'uri'
require 'json'
require 'cgi'

module Msgwow
  class Message

    attr_accessor :message, :mobiles, :sender, :route,
                  :response, :flash, :schedule_time,
                  :unicode, :campaign, :ignore_ndnc, :country

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
      @route = new_route if new_route && [1,4].include?(new_route)
    end

    def flash=(flash_value)
      if flash_value == true || flash_value.to_i == 1
        @flash = '1'
      else
        @flash = false
      end
    end

    def unicode=(unicode_value)
      if unicode_value == true || unicode_value.to_i == 1
        @unicode = '1'
      else
        @unicode = false
      end
    end

    def country=(country_code)
      @country = country_code if country_code.match(/\A\d+\z/)
    end

    def schedule_time=(date_time)
      # No strict validation here, just the format
      @schedule_time = date_time if date_time.match(/\A\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\z/)
    end

    def ignore_ndnc=(value)
      if value == true || value.to_i == 1
        @ignore_ndnc = '1'
      end
    end

    def options=(options)
      [:sender, :route, :flash, :schedule_time, :unicode, :country, :campaign].each do |attr|
        self.public_send("#{attr}=", options[attr]) if options.has_key?(attr)
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
      # Optional arguments
      [:flash, :unicode, :country, :campaign].each do |attr|
        attr_value = self.public_send(attr)
        params[attr.to_s] = attr_value if attr_value
      end
      params['schtime'] = self.schedule_time unless self.schedule_time.nil?
      params['ignoreNdnc'] = self.ignore_ndnc unless self.ignore_ndnc.nil?

      req.set_form_data(params)
      result = http.start { |http| http.request(req) }
      self.response = result
      return 'test'
    end
  end
end