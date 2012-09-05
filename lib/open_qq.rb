require 'open_qq/gateway'

module OpenQq

  class << self
    attr_reader :gateway

    def init(options)
      @gateway ||= OpenQq::Gateway.new(options["appid"], options["appkey"], options["env"])
    end

    def setup(&block)
      yield gateway if block_given?
      self
    end

  end

  # Example:
  #
  # OpenQq.get('/v3/user/get_info', {:appid => '11'})
  #
  # OpenQq.get('/v3/user/get_info?appid=11')
  #
  # OpenQq.get('/v3/user/get_info') do |body|
  #   # some code
  # end
  #
  def self.get(url, options = {}, &block)
    #yield gate_way if block_given?
    gateway.call(url, :GET, options)
  end

  # Example:
  #
  # OpenQq.post('/v3/user/get_info', {:appid => '11'})
  #
  # OpenQq.post('/v3/user/get_info', {:appid => '11'}) do |body|
  #   # some code
  # end
  #
  def self.post(url, options = {}, &block)
    #yield gate_way if block_given?
    gateway.call(url, :POST, options)
  end

end
