require 'rubygems'
require 'spork'

Spork.prefork do
  require 'rack/test'
  require 'bundler'

  Bundler.require(:default, :test)

  require 'webmock/rspec'

  require './lib/stoplight'

  VCR.configure do |c|
    c.cassette_library_dir = 'fixtures/vcr_cassettes'
    c.hook_into :webmock
  end

  RSpec.configure do |config|
    config.include Rack::Test::Methods
  end
end

Spork.each_run do

end
