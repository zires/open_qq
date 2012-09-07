# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
require 'rubygems' if RUBY_VERSION < '1.9'
require 'open_qq/gateway'

module OpenQq

  class << self
    
    attr_reader :gateway

    def init(options)
      @gateway ||= OpenQq::Gateway.new(options["appid"], options["appkey"], options["env"])
    end

    def setup(&block)
      yield gateway if block_given?
      self
    end

  end

  # Examples:
  #
  # OpenQq.get('/v3/user/get_info', {:appid => '11'})
  #
  # OpenQq.get('/v3/user/get_info?appid=11')
  #
  def self.get(url, options = {})
    gateway.call(url, :get, options)
  end

  # Example:
  #
  # OpenQq.post('/v3/user/get_info', {:appid => '11'})
  #
  def self.post(url, options = {})
    gateway.call(url, :post, options)
  end

end
