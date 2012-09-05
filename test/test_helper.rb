begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "test/unit"
require 'minitest/autorun'

# Enable turn if it is available
begin
  require 'turn'
rescue LoadError
end

require 'open_qq'
