require 'uri'
require 'base64'
require 'openssl'
require 'net/http'

module OpenQq
  class Gateway

    # - appid  : your app id.
    # - appkey : your app secret key.
    # - env    : about environment host url.production <http://openapi.tencentyun.com> test <http://119.147.19.43>
    attr_accessor :appid, :appkey, :env, :options

    def initialize(appid, appkey, env)
      @appid   = appid
      @appkey  = appkey
      self.env = env
    end

    def call(url, http_method, options = {})
      options[:sig] = signature( url, http_method, options.merge({:appid => @appid}) )
      send( http_method.to_s.downcase, url, options.merge({:appid => @appid}) )
    end

    # override
    def env=(env)
      @env  = env
      uri   = URI.parse(env)
      @http = Net::HTTP.new(uri.host, uri.port)
    end

    private

    def get(url, options)
      parsed_options = options.map{|k,v| "#{k}=#{v}"}.join('&')
      response = @http.request( Net::HTTP::Get.new("#{url}?#{parsed_options}") )
      response.body
    end

    def post(url, options)
      request = Net::HTTP::Post.new(url)
      request.set_form_data(options)
      response = @http.request(request)
      response.body
    end

    def signature(url, http_method, options)
      escape_url = URI.escape( url, /[^\.\-_\da-zA-Z]/ )
      escape_opt = URI.escape( options.sort{|a,b| a.to_s <=> b.to_s}.map{|kv| "#{kv.first}=#{kv.last}" }.join('&'), /[^\.\-_\da-zA-Z]/ )
      hexdigest  = OpenSSL::HMAC.hexdigest 'sha1', "#{@appkey}&", "#{http_method}&#{escape_url}&#{escape_opt}"
      Base64.encode64(hexdigest).rstrip
    end

  end
end