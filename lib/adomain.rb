require "adomain/version"
require "addressable/uri"
require "logger"

class Adomain
  class << self
    # [] is a convenience method to subdomain the URL,
    # or optionally domain or subdomain_www.
    #   Adomain["http://abc.xyz.com"]               # => "abc.xyz.com"
    #   Adomain["http://abc.xyz.com", true]         # => "xyz.com"
    #   Adomain["http://www.xyz.com", false, true]  # => "www.xyz.com"
    #   Adomain["http://abc.xyz.com", false, false] # => "abc.xyz.com"
    def [](string, domain = false, www = false)
      domain(string, domain, www)
    end

    # domain is the base method for only the domain from parse_for_domain
    #   Adomain.domain "http://www.xyz.com" # => "xyz.com"
    #   Adomain.domain "http://abc.xyz.com" # => "xyz.com"
    #   Adomain.domain "http://xyz.com"     # => "xyz.com"
    def domain(string, domain = true, www = false)
      opts = { :keep_www => www, :strip_subdomain => domain }
      parse_for_domain(string, opts)
    end

    # subdomain is a convenience method for the domain with
    # any subdomain except "www" from parse_for_domain
    #   Adomain.subdomain "http://www.xyz.com" # => "xyz.com"
    #   Adomain.subdomain "http://abc.xyz.com" # => "abc.xyz.com"
    #   Adomain.subdomain "http://xyz.com"     # => "xyz.com"
    def subdomain(string, www = false)
      domain(string, false, www)
    end

    # subdomain_www is a convenience method for the domain with
    # any subdomain including "www" from parse_for_domain
    #   Adomain.subdomain_www "http://www.xyz.com" # => "www.xyz.com"
    #   Adomain.subdomain_www "http://abc.xyz.com" # => "abc.xyz.com"
    #   Adomain.subdomain_www "http://xyz.com"     # => "xyz.com"
    def subdomain_www(string)
      subdomain(string, true)
    end

    private
      # parse_for_domain accepts one hash of arguments that allow
      # changes to the parsing behavior of domains
      # opts defaults to
      #   opts = {
      #     :keep_www => false,
      #     :strip_subdomain => false
      #   }
      # parse_for_domain returns the domain, whose exact details will
      # depend on the opts hash, found in the string, or nil if the
      # provided string does not contain a valid domain.
      def parse_for_domain(string, opts = {})
        # normalize the string for domain parsing
        raw = string.strip

        # Add a scheme to the string in case it has none,
        # because it is required for parsing well with URI
        copy   = "https://#{raw}" unless "#{raw}".match("://")
        copy ||= raw

        # Strip the top www subdomain unless user opted out.
        copy   = copy.gsub(/:\/\/www\./i, "://") unless opts[:keep_www]

        # Parse the string
        uri = Addressable::URI.parse(copy)

        # The string did not contain a parsable domain.
        return nil if uri.domain.nil?

        # choose between the domain without the subdomain,
        # or the whole host, which contains the subdomain.
        domain   = uri.domain if opts[:strip_subdomain]
        domain ||= uri.host

        return domain
      rescue Addressable::URI::InvalidURIError => e
        nil
      end

      def logger
        @logger ||= defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      end # https://stackoverflow.com/a/30623846/1651458
  end
end
