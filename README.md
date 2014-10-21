# Dalli::Extra

A small gem which adds some much needed methods to Dalli. The idea of this gem came after reading this post http://www.darkcoding.net/software/memcached-list-all-keys/ and seeing a similar gem "https://github.com/seratch/dallish"  

## Note

As this gem creates telent connections, its slower than Dalli. So its good fit for non-production uses like debugging, development or in background jobs.

## Installation

Add this line to your application's Gemfile:

    gem 'dalli-extra'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dalli-extra

## Usage
	```ruby
	require 'dalli'
	require 'dalli/extra'
	dc = Dalli::Client.new(['localhost:11211','localhost:11212'], :expires_in => 300)

	all_keys = dc.keys
	regex_matching_keys = dc.keys(/abc/)
	string_containing_keys = dc.keys('abc')

	all_pairs = dc.pairs
	regex_matching_pairs = dc.pairs(/abc/)
	string_containing_pairs = dc.pairs('abc')

	count = dc.delete_matched(/abc/) or
	count = dc.delete_macthed('abc')
	
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
