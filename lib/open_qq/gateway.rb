# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
require 'open_qq/signature'
require 'open_qq/error'
require 'ostruct'
require 'net/https'

module OpenQq
  class Gateway

    OPEN_HTTP_TRANSLATE_ERROR = 2001

    attr_accessor :appid, :appkey, :env

    # @param [String] appid
    # @param [String] appkey
    # @param [String] env 调用的环境地址.生产环境: <http://openapi.tencentyun.com> 测试环境: <http://119.147.19.43>
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
      # HTTPS
      if uri.scheme == "https"
        @http.use_ssl     = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    # @param [String] url which api you want to call
    # @param [Hash] params extra params attach to the url
    # @param [options] options
    # 
    # @example
    #   gateway   = OpenQq::Gateway.new('1111', '2222', 'http://119.147.19.43')
    #   user_info = gateway.get('/v3/user/get_info', {:openid => '11'} )
    #   user_info.nickname # => foo
    #
    # @example available option
    #   :raw => true will raw the output
    #   user_info = gateway.get('/v3/user/get_info', {:openid => '11'}, {:raw => true} )
    #   user_info.nickname # => '{"nickname":"foo"}'
    #
    # @return (see #call)
    def get(url, params = {}, options = {})
      parsed_params = each_pair_escape( wrap(:get, url, params) ).map{|k,v| "#{k}=#{v}"}.join('&')
      get_request   = Net::HTTP::Get.new("#{url}?#{parsed_params}")
      self.call( get_request, options.merge(:format => params[:format]) )
    end

    # @param (see #get)
    #
    # @return (see #call)
    def post(url, params = {}, options = {})
      post_request = Net::HTTP::Post.new(url)
      post_request.set_form_data wrap(:post, url, params)
      self.call( post_request, options.merge(:format => params[:format]) )
    end

    def wrap(http_method, url, params)
      params = params.merge(:appid => @appid)
      params[:sig] = signature( "#{@appkey}&", make_source(http_method.to_s.upcase, url, params) )
      params
    end

    protected

    # Call the request and format the output
    # @param [Net::HTTP::Request] request be called
    # @param [Hash] options some option used to format output
    #
    # @return [String, Object] unformatted string result or parsed OpenStruct instance
    def call(request, options)
      response = begin
        @http.request(request)
      rescue Exception => e
        Error.new(OPEN_HTTP_TRANSLATE_ERROR, "#{e.message}\n#{e.backtrace.inspect}", options[:format])
      end
      
      return response.body if options[:raw] || options[:format] == 'xml'

      OpenStruct.new( JSON.parse(response.body) )
    end

    private

    include Signature

  end
end