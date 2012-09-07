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
    assert_equal 'foo', @gateway.call('/v3/user/get_info', :get).nickname
  end

  def test_call_get_request_with_params
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'json' }
    assert_equal 'foo', @gateway.call('/v3/user/get_info', :get, params).nickname
  end

  def test_call_get_request_with_xml_format
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'xml' }
    assert_equal '<?xml version="1.0" encoding="UTF-8"?>', @gateway.call('/v3/user/get_info', :get, params)
  end

  def test_call_get_request_without_format_param
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou }
    assert_equal 'foo', @gateway.call('/v3/user/get_info', :get, params).nickname
  end

  def test_call_get_request_with_unknow_format_param
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'ruby'}
    assert_equal 'foo', @gateway.call('/v3/user/get_info', :get, params).nickname
  end

  def test_call_post_request
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 'foo', @gateway.call('/v3/user/get_info', :post, params).nickname
  end

  def test_call_post_request_with_raw_output
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal '{ "ret": 0, "is_lost": 0, "nickname": "foo" }', @gateway.call('/v3/user/get_info', :post, params, :raw => true)
  end

  def test_open_http_translate_error
    gateway = OpenQq::Gateway.new('123456', @appkey, @env)
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 2001, gateway.call('/v3/user/get_info', :get, params).ret
  end

  def test_call_has_alias_method_open
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 'foo', @gateway.open('/v3/user/get_info', :post, params).nickname
  end

end