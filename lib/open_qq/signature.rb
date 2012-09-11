# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
require 'base64'
require 'openssl'
require 'uri'

module OpenQq
  module Signature
    
    def signature(key, source)
      Base64.encode64( OpenSSL::HMAC.digest('sha1', key, source) ).rstrip
    end

    def url_escape(url)
      URI.escape(url, /[^\.\-_\da-zA-Z]/)
    end

    def each_pair_escape(options)
      options.inject({}){|h,(k,v)| h[url_escape(k.to_s)] = url_escape(v.to_s);h}
    end

    def make_source(http_method, url, options)
      escape_opt = url_escape( options.sort_by{|k,v| k.to_s}.map{|kv| "#{kv.first}=#{kv.last}" }.join('&') )
      "#{http_method}&#{url_escape(url)}&#{escape_opt}"
    end

    def make_callback_source(http_method, url, options)
      escape_opt = options.sort_by{|k,v| k.to_s}.map do |kv|
        value = URI.escape(kv.last, /[^0-9a-zA-Z!*()]/)
        "#{kv.first}=#{value}"
      end.join('&')
      "#{http_method}&#{url_escape(url)}&#{url_escape(escape_opt)}"
    end

    def verify_sig(sig, key, http_method, url, options)
      sig == url_escape( signature(key, make_callback_source(http_method, url, options)) )
    end

  end
end