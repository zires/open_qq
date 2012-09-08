# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
require 'open_qq/gateway'

module OpenQq
  class Request < Gateway

    attr_accessor :url, :options

    def initialize(options)
      options  = options.dup
      appid    = options.delete(:appid)
      appkey   = options.delete(:appkey)
      env      = options.delete(:env)
      @url     = options.delete(:url)
      @options = options
      super(appid, appkey, env)
    end

    # @see Gateway#get
    def get(params = {}, options = @options)
      super(@url, params, options)
    end
    
    # @see Gateway#get
    def post(params = {}, options = @options)
      super(@url, params, options)
    end

  end
end