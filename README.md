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
  c.authkey = "msgwow API key"
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
* **route**  : **1** for promotional route and **4** for transactional route.
  `Msgwow.send_message('message', '9538xxxxxx', sender: 'MYAPPS', route: 1)`
* **country**: 0 for international,1 for USA, 91 for India (integer only).
  `Msgwow.send_message('message', '9538xxxxxx', country: 1)`
* **flash**  : **1** or **true** to send a flash message.
  `Msgwow.send_message('message', '9538xxxxxx', flash: true)`
  or you can send a flash message directly with `send_flash_message`  and it supports all other options.
  `Msgwow.send_flash_message('message', '9538xxxxxx', sender: 'ALERT')`
* **unicode**  : **1** or **true** to send a unicode message.
  `Msgwow.send_message('message', '9538xxxxxx', unicode: true)`
  or you can send a unicode message directly with `send_unicode_message`  with all other options.
  `Msgwow.send_unicode_message('message', '9538xxxxxx', sender: 'ALERT')`
* **ignore_ndnc** : **1** or **true** to make system, ignore all NDNC Numbers.
  `Msgwow.send_message('message', '9538xxxxxx', ignore_ndnc: true)`
* **campaign**    : Name of the campaign, you want to start.
  `Msgwow.send_message('message', '9538xxxxxx', campaign: 'Christmas Offer')`
* **schedule_time** : Date and Time of when you want to schedule the SMS to be sent.
Time format will be Y-m-d H:M:S .
  `Msgwow.send_message('message', '9538xxxxxx', schedule_time: '2017-02-28 18:24:00')`
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sajan45/msgwow.

## TODO

* Support for phonebook features.
* Specs.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

