# Msgwow
Unofficial Ruby wrapper for **msgwow.com** API.
This will work for **sms.fly.biz** too, since both have same backend.

## Installation

Add:
`gem 'msgwow', :git => 'https://github.com/sajan45/msgwow'`
or `gem 'msgwow'` to your `Gemfile`

or install from Rubygems:
Run `gem install msgwow`

## Usage

Configure the default settings

```ruby
Msgwow.config do |c|
  c.sender = "MYAPPS"   # Default sender id is MSGWOW
  c.route = 1           # Default route is 4, which is for Transactional SMS
  c.api_hash = "msgwow hash"
end
```

Alternative to above configuration, you can just set environment variables for msgwow authkey and you are ready to go (Default values will be used for other configuration).

```
MSGWOW_AUTH_KEY = "YOUR API KEY"
```

Sending SMS:
```ruby
sms = Msgwow.send_message(message, numbers, options)
 # Msgwow.send_message('hello world', '9853xxxxxx')
status = sms.response['body']

# status can be a response string or error message
# see msgwow documentation for response message
```
or you can create message manually:
```ruby
msg = Msgwow::Message.new
msg.message = "your order is received successfully"
msg.numbers = ["9853xxxxxx"]
msg.send!
```
`message` is a string type argument.
`numbers` argument can be `string`, `integer` or `array` of `strings` or `integers`

All of the below can be valid for numbers argument:
* '9853xxxxxx'
* 9853xxxxxx
* ['9853xxxxxx', '9856xxxxxx']
* ['8894xxxxxx', 7504xxxxxx]

Every individual **Number** should be at least 10 character long, containing all numeric character.
Below are valid individual numbers irrespective of string or integer:
* 9876543210
* 919876543210
* +919876543210

But numbers like *987654321* (less than 10 digit) or *98765abcde* (containing non numeric character) is not valid.

#### Options
The third optional argument for `send_message` method is a Hash object.
* **sender** : You can override sender by passing a `sender` option.
  `Msgwow.send_message('message', '9538xxxxxx', sender: 'MYAPPS')`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sajan45/msgwow.

## TODO

* Support for more options like schedule time
* Specs for features

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

