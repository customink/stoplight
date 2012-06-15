require 'rubygems'
require 'spork'

Spork.prefork do
  require 'rack/test'
  require 'bundler'

  Bundler.require(:default, :test)

  require 'webmock/rspec'

  require './lib/stoplight'

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :webmock
    c.default_cassette_options = { :record => :new_episodes }
  end

  RSpec.configure do |c|
    c.include Rack::Test::Methods
    c.extend VCR::RSpec::Macros
  end
end

Spork.each_run do

end
