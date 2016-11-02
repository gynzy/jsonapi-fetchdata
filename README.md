# JSONAPI::Fetchdata

Many JSONAPI gems are being developed, mostly focusing on serialization.
Few have implemented the parameters defined in the FetchData specifications.

This gem aims to focus on doing just that specific task.
Making it easy to add FetchData parameters to gems which don't have support for them.
The specific string delimiters noted in FetchData parameters, are not supported in Rack by default.
We attempt to parse the parameter values into a hash structure.
Trying to mimick the hash style notation used in ActiveRecord Querying.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsonapi-fetchdata'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsonapi-fetchdata

## Usage

add as middleware to Rails in config/application.rb

```ruby
config.middleware.insert_after ActionDispatch::ParamsParser, 'JSONAPI::FetchData::Middleware'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jsonapi-fetchdata.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
