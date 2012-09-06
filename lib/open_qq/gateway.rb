require 'open_qq/signature'
require 'net/http'

module OpenQq
  class Gateway
    # - appid  : your app id.
    # - appkey : your app secret key.
    # - env    : about environment host url.production <http://openapi.tencentyun.com> test <http://119.147.19.43>
    attr_accessor :appid, :appkey, :env

    def initialize(appid, appkey, env)
      @appid   = appid
      @appkey  = appkey
      self.env = env
    end

    # override
    def env=(env)
      @env  = env
      uri   = URI.parse(env)
      @http = Net::HTTP.new(uri.host, uri.port)
    end

    def call(url, http_method, options = {})
      options = options.merge({:appid => @appid})
      options[:sig] = signature "#{appkey}&", make_source(http_method.to_s.upcase, url, options)
      
      response = begin
        @http.request( send(http_method, url, options_escape(options)) )
      rescue Exception => e
        raise RuntimeError.new("#{e.message}\n#{e.backtrace.inspect}")
      end
      
      response.body
    end

    protected

    def get(url, options)
      parsed_options = options.map{|k,v| "#{k}=#{v}"}.join('&')
      Net::HTTP::Get.new("#{url}?#{parsed_options}")
    end

    def post(url, options)
      Net::HTTP::Post.new(url).tap do |request|
        request.set_form_data(options)
      end
    end

    private

    include Signature

  end
end