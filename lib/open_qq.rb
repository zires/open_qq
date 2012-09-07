# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
require 'rubygems' if RUBY_VERSION < '1.9'
require 'json'
require 'open_qq/gateway'

module OpenQq
  class << self

    attr_reader :gateway

    # @param [Hash] options
    def init(options)
      @gateway ||= OpenQq::Gateway.new(options["appid"], options["appkey"], options["env"])
    end

    # OpenQq.get('/v3/user/get_info', {:appid => '11'})
    # @see Gateway#call
    def get(url, options = {}, raw)
      gateway.call(url, :get, options, raw)
    end

    # OpenQq.post('/v3/user/get_info', {:appid => '11'})
    # @see Gateway#call
    def post(url, options = {}, raw)
      gateway.call(url, :post, options, raw)
    end

  end
end
