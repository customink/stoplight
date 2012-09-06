require 'rubygems'
require 'bundler'

Bundler.require
require 'active_support/inflector'

require 'lib/stoplight'
require 'rabl'
Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
end
Rabl.register!

require 'application'

require 'logger'
$logger = Logger.new('tmp/application.log')
use Rack::CommonLogger, $logger
