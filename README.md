# Adomain

Simplified domain parsing

```ruby
Adomain["abc.xyz.com/path&key=value"]
# => "abc.xyz.com"

Adomain["https://abc.xyz.com"]
# => "abc.xyz.com"

Adomain["https://www.xyz.com"]
# => "xyz.com"
```

Adomain returns the URL host, stripping 'www' by default,
scheming your URL if necessary (with "https://").
Optionally, you can strip subdomains or keep 'www' subdomains – see below.

[`Addressable::URI.parse`](https://github.com/sporkmonger/addressable#example-usage)
performs the parsing.

## Other methods and options

`[]` is an alias for `Adomain.subdomain()`

```ruby
Adomain["http://abc.xyz.com"] == Adomain.subdomain("http://abc.xyz.com")
# => true
```

Adomain only has a few other public methods:

### Stripping all subdomains

```ruby
Adomain.domain "http://abc.xyz.com" # => "xyz.com"
```

### Keeping all subdomains, including 'www'

```ruby
Adomain.subdomain_www "http://www.xyz.com" # => "www.xyz.com"
```

### Domain options

Optionally, each method accepts boolean values,
allowing you to contort the method to do something other
than what it says it does. Don't do this, unless you want to.

#### A gotcha: Adomain returns nil for some invalid values

Because Adomain adds a scheme to any string passed to it,
schemeless-but-otherwise valid strings do not raise errors.
Additionally, Adomain rescues InvalidURIError errors,
and instead returns nil.

```ruby
Adomain["hola"]     # => nil
Adomain["::::::::"] # => nil
Adomain[""]         # => nil
Adomain["{}"]       # => nil
```

#### NOTE: InvalidURIError are now caught in >= version 0.2

With 0.2 `Addressable::URI::InvalidURIError`s are now caught
and ignored. Nil is returned.

```ruby
Gem::Version.new(Adomain::VERSION) >= Gem::Version.new(0.2) # => true
Adomain["hola"]     # => nil
Adomain["::::::::"] # => nil
Adomain[""]         # => nil (formerly raised a Addressable::URI::InvalidURIError)
Adomain["{}"]       # => nil (formerly raised a Addressable::URI::InvalidURIError)
```

### Convenience Addressable passthroughs

These methods are simply passed through to parsed
Addressable URI objects, and respond accordingly.
These are presented for your convenience, and will track with
your version of Addressable.

```ruby
Adomain.path "http://www.xyz.com/pages/123" # => "/pages/123"
Adomain.path "{{{{{" # => "{{{{{"
Adomain.scheme "http://www.xyz.com/pages/123" # => "http"
Adomain.scheme "harrison:ford" # => "harrison"
Adomain.query_values "https://maximumfun.org/donate?amt=20USD" # => {"amt"=>"20USD"}
Adomain.query_values "google.com?q=gagh.biz" # => {"q"=>"gagh.biz"}
```

However, they are rescued from InvalidURIError,
like in other parts of the gem.

```ruby
Adomain.path "::::::::::::" #=> nil
Adomain.scheme "::::::::::::" #=> nil
Adomain.query_values "::::::::::::" #=> nil
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adomain'
```

Or install it yourself as:

    $ gem install adomain



## Development

File bugs against the GitHub issue tracker and pull requests to match,
where possible.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/samnissen/adomain. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Adomain project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/samnissen/adomain/blob/master/CODE_OF_CONDUCT.md).
