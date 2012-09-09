# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
require 'rubygems' if RUBY_VERSION < '1.9'
require 'json'
require 'open_qq/request'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash/indifferent_access'

module OpenQq
  class << self

    def setup(options = {})
      options    = options.with_indifferent_access
      @gateway ||= OpenQq::Gateway.new(options[:appid], options[:appkey], options[:env])
      yield @gateway if block_given?
    end

    # @see Gateway#get
    delegate :appid, :appkey, :env, :get, :post, :to => :@gateway

    # @example
    #   OpenQq.start('/v3/user/get_info', { :appid => 123 }) do |request|
    #     request.get({:openid => '111'})
    #   end
    def start(url, options)
      request = OpenQq::Request.new(options.with_indifferent_access)
      if block_given?
        yield request
      else
        request
      end
    end

  end
end

require 'open_qq/railtie' if defined?(Rails)
