QyWechat
====


## example:

    $./bin/console


~~~ruby
c = QyWechat::Api.new 'corpid-123',
                      "corpsecret-123",
                      "agentid-123", # agentid can be absent
                      true # set debug_mode to true to show request debug log message, the omission of it will set it to false
c.corpid
c.corpsecret
c.agentid

c.access_token # access_token will auto updated itself if expired when you accessed it

c.gen_qrConnect_link(appid: "appid-123", # can be absent
                     agentid: "agentid-123", can be absent
                     redirect_uri: "http://you-webside-domain.com/path/abc",
                     state: "url-state-params-of-the-redirect-uri")

c.user_getuserinfo(code: "12343")
c.raw_get("user/getuserinfo, code: "12343") # same as previous line code, but use a low level method to do the reqeust.

c.debug_mode = false # turn off debug mode
~~~





# others
Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/qy_wechat`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qy_wechat'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install qy_wechat

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/qy_wechat. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/qy_wechat/blob/master/CODE_OF_CONDUCT.md).


## Code of Conduct

Everyone interacting in the QyWechat project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/qy_wechat/blob/master/CODE_OF_CONDUCT.md).
