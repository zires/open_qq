require 'test_helper'

class OpenQq::GatewayTest < MiniTest::Unit::TestCase

  def setup
    # 测试用例的签名通过腾讯联调工具产生 http://open.qq.com/tools
    @appid   = 12345
    @appkey  = '228bf094169a40a3bd188ba37ebe8723'
    @env     = 'http://119.147.19.43'
    @gateway = OpenQq::Gateway.new(@appid, @appkey, @env)
  end

  def test_call_get_request_without_params
    assert_equal 'foo', @gateway.get('/v3/user/get_info').nickname
  end

  def test_call_get_request_with_params
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'json' }
    assert_equal 'foo', @gateway.get('/v3/user/get_info', params).nickname
  end

  def test_call_get_request_with_xml_format
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'xml' }
    assert_equal '<?xml version="1.0" encoding="UTF-8"?>', @gateway.get('/v3/user/get_info', params)
  end

  def test_call_get_request_without_format_param
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou }
    assert_equal 'foo', @gateway.get('/v3/user/get_info', params).nickname
  end

  def test_call_get_request_with_unknow_format_param
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'ruby'}
    assert_equal 'foo', @gateway.get('/v3/user/get_info', params).nickname
  end

  def test_call_post_request
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 'foo', @gateway.post('/v3/user/get_info', params).nickname
  end

  def test_call_post_request_with_raw_output
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal '{ "ret": 0, "is_lost": 0, "nickname": "foo" }', @gateway.post('/v3/user/get_info', params, :raw => true)
  end

  def test_open_http_translate_error
    gateway = OpenQq::Gateway.new('123456', @appkey, @env)
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 2001, gateway.get('/v3/user/get_info', params).ret
  end

  def test_https_request
    gateway = OpenQq::Gateway.new(@appid, @appkey, 'https://119.147.19.43')
    http = gateway.instance_variable_get(:@http)
    assert_equal 443, http.port
    assert_equal '119.147.19.43', http.address
    assert http.use_ssl?
  end

end