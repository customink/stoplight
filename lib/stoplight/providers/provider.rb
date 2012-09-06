#
# This is a base provider that all providers must inherit from
#
require 'httparty'
require 'rack/commonlogger'
require 'uri'

unless $logger
  require 'logger'
  $logger = Logger.new('tmp/application.log')
end

# Provider is an abstract class that all providers inherit from. It requires that a specified format be returned. This way, stoplight
# doesn't care who it's talking to, as long as it guarantees certain information.
module Stoplight::Providers
  class Provider
    include HTTParty
    require 'digest/md5'

    attr_reader :options, :response

    # Initializes a hash `@options` of default options
    def initialize(options = {})
      if options['url'].nil?
        raise ArgumentError, "'url' must be supplied as an option to the Provider. Please add 'url' => '...' to your hash."
      end

      @options = options

      # load the data
      @response = load_server_data
    end

    # `projects` must return an array of Stoplight::Project
    # see Stoplight::Project for more information on the spec
    def projects
      raise Stoplight::Exceptions::NoParserError.new "No projects parser provided. All Stoplight providers must provide a projects method!"
    end

    # The default "all builds" path for a given provider
    def builds_path
      @options['builds_path'] || '/'
    end

    protected
    # Makes a request to the given server `url` and assigns an instance variable
    # `@response` to the result. It only returns a string. The `result` method is
    # responsible for parsing the string into a usable hash.
    #
    # Valid options include:
    #   - `path`: the URL path (after base)
    #   - `url_options`: additional URL options, such as querystrings
    #   - `method`: the HTTP method (get, post, put, etc)
    def load_server_data(options = {})
      url = @options['url'].chomp('/') + '/' + (options[:path] || builds_path).chomp('/').reverse.chomp('/').reverse

      url_options = {}

      if @options['username'] || @options['password']
        url_options[:basic_auth] = {
          :username => @options['username'],
          :password => @options['password']
        }
      end

      if @options['owner_name']
        url_options[:query] = {
          :owner_name => @options['owner_name']
        }
      end

      url_options[:http_proxyaddr] ||= @options['http_proxyaddr']
      url_options[:http_proxyport] ||= @options['http_proxyport']
      url_options[:http_proxyuser] ||= @options['http_proxyuser']
      url_options[:http_proxypass] ||= @options['http_proxypass']

      # merge with any additional options provided
      url_options.merge(options[:url_options]) if options[:url_options]

      url_options.delete_if { |k,v| v.nil? }

      http_method = options[:method] || 'get'
      response = HTTParty.send(http_method.downcase.to_sym, url, url_options)

      if [200, 301, 302].include?(response.code)
        return response
      else
        $logger.error "Response code for #{url} was #{response.code}"
        nil
      end
    rescue Exception => e
      $logger.error "#{e.to_s}: `#{url}`"
      nil
    end
  end
end
