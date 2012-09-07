# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
require 'open_qq/signature'
require 'net/http'
require 'ostruct'
require 'json'

module OpenQq
  class Gateway

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
    end

    # @param [String] url which api you want to call
    # @param [String, Symbol] http_method
    # @param [Hash] options extra options attach to the url
    # @param [Boolean] raw will return raw output
    #
    # == Examples:
    #
    #   gateway = OpenQq::Gateway.new('1111', '2222', 'http://119.147.19.43')
    #   user_info = gateway.call('/v3/user/get_info', :get)
    #   user_info = gateway.call('/v3/user/get_info', :post, {:openid => 'bar'})
    #
    #   user_info.nickname # => foo
    #
    #   user_info = gateway.call('/v3/user/get_info', :post, {:openid => 'bar'}, true)
    #   puts user_info # => '{"nickname":"foo"}'
    #
    # @return [String, Object] unformatted result or parsed result
    def call(url, http_method, options = {}, raw = false)
      options = options.merge({:appid => @appid})
      options[:sig] = signature "#{appkey}&", make_source(http_method.to_s.upcase, url, options)
      
      response = begin
        @http.request( send(http_method, url, each_pair_escape(options)) )
      rescue Exception => e
        raise RuntimeError.new("#{e.message}\n#{e.backtrace.inspect}")
      end
      
      return response.body if raw || options[:format] == 'xml'

      OpenStruct.new( JSON.parse(response.body) )
    end

    alias open call

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