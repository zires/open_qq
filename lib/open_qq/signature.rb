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

    def options_escape(options)
      options.inject({}){|h,(k,v)| h[url_escape(k.to_s)] = url_escape(v.to_s);h}
    end

    def make_source(http_method, url, options)
      escape_opt = url_escape( options.sort_by{|k,v| k.to_s}.map{|kv| "#{kv.first}=#{kv.last}" }.join('&') )
      "#{http_method}&#{url_escape(url)}&#{escape_opt}"
    end

  end
end