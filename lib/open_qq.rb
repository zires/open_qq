# encoding: utf-8
#
# --
# @author zires
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
    delegate :appid, :appkey, :env, :get, :post, :wrap, :to => :@gateway

    # @example
    #   OpenQq.call('/v3/user/get_info', { :appid => 123 }) do |request|
    #     request.get({:openid => '111'})
    #   end
    def call(url, options)
      request = OpenQq::Request.new(options.with_indifferent_access)
      if block_given?
        yield request
      else
        request
      end
    end

    alias start call

    # @example
    #   params = {openid: 'test001', appid: '33758', sig: 'VvKwcaMqUNpKhx0XfCvOqPRiAnU%3D'}
    #   OpenQq.verify_callback_sig(:get, '/cgi-bin/temp.py', params)
    #   #diffenert key
    #   OpenQq.verify_callback_sig(:get, '/cgi-bin/temp.py', params, 'xxxxxx')
    #
    # @return [Boolean]
    def verify_callback_sig(http_method, url, params, key = nil)
      key  ||= appkey
      params = params.dup
      sig    = params.delete('sig') || params.delete(:sig)
      Gateway.verify_sig(sig, "#{key}&", http_method.to_s.upcase, url, params)
    end
    
  end
end

require 'open_qq/railtie' if defined?(Rails)
