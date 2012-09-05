require 'uri'
require 'base64'
require 'openssl'

module OpenQq
  module Common

    attr_reader   :appkey, :openid, :openkey, :appid, :pf, :options
    attr_accessor :env

    def initialize(appkey, options = {})
      @appkey = appkey
      [ :openid, :openkey, :appid, :pf ].each do |attr|
        raise "#{attr} can't be blank" if options[attr].nil?  
        instance_variable_set "@#{attr}".to_sym, options[attr]
      end
      @env = options.delete(:env).to_s == 'production' ? 'openapi.tencentyun.com' : '119.147.19.43'
      options.delete(:sig)
      @options = options
    end

    def sig(url, http_method = :GET)
      escape_opt = URI.escape( @options.sort.map{|kv| "#{kv.first}=#{kv.last}" }.join('&') )
      digest = OpenSSL::HMAC.digest 'sha1', "#{http_method}&#{URI.escape(url)}&#{escape_opt}", "#{@appkey}&"
      Base64.encode64(digest)
    end

  end
end