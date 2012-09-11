require 'test_helper'

class OpenQqTest < MiniTest::Unit::TestCase
  
  def setup
    @options = { :appid  => 12345,
                 :appkey => '228bf094169a40a3bd188ba37ebe8723',
                 :env    => 'http://119.147.19.43',
                 :url    => '/v3/user/get_info',
              }
    OpenQq.setup(@options)
  end

  def teardown
    # Need setup back for the rest test
    OpenQq.setup{|c| c.appid = 12345;c.appkey ='228bf094169a40a3bd188ba37ebe8723'}
  end

  def test_OpenQq_is_a_module
    assert_kind_of Module, OpenQq
  end

  def test_setup
    assert_equal 12345, OpenQq.appid
    assert_equal '228bf094169a40a3bd188ba37ebe8723', OpenQq.appkey
    assert_equal 'http://119.147.19.43', OpenQq.env
    OpenQq.setup do |config|
      config.appid = 'foo'
    end
    assert_equal 'foo', OpenQq.appid
  end

  # Copy from gateway_test

  def test_call_get_request_without_params
    assert_equal 'foo', OpenQq.get('/v3/user/get_info').nickname
  end

  def test_call_get_request_with_params
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'json' }
    assert_equal 'foo', OpenQq.get('/v3/user/get_info', params).nickname
  end

  def test_call_get_request_with_xml_format
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'xml' }
    assert_equal '<?xml version="1.0" encoding="UTF-8"?>', OpenQq.get('/v3/user/get_info', params)
  end

  def test_call_get_request_without_format_param
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou }
    assert_equal 'foo', OpenQq.get('/v3/user/get_info', params).nickname
  end

  def test_call_get_request_with_unknow_format_param
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'ruby'}
    assert_equal 'foo', OpenQq.get('/v3/user/get_info', params).nickname
  end

  def test_call_post_request
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 'foo', OpenQq.post('/v3/user/get_info', params).nickname
  end

  def test_call_post_request_with_raw_output
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal '{ "ret": 0, "is_lost": 0, "nickname": "foo" }', OpenQq.post('/v3/user/get_info', params, :raw => true)
  end

  def test_open_http_translate_error
    OpenQq.setup do |config|
      config.appid = '123456'
    end
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 2001, OpenQq.get('/v3/user/get_info', params).ret
  end

  def test_call_wont_change_get_and_post_method
    params  = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'json' }
    respond = OpenQq.call('/v3/user/get_info', @options){|r| r.get(params) }
    assert_equal 'foo', OpenQq.get('/v3/user/get_info', params).nickname
    assert_equal 'foo', respond.nickname
  end

  def test_call_has_alise_method_start
    params  = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'json' }
    respond = OpenQq.start('/v3/user/get_info', @options){|r| r.get(params) }
    assert_equal 'foo', OpenQq.get('/v3/user/get_info', params).nickname
    assert_equal 'foo', respond.nickname
  end

  def test_verify_callback_sig
    key = '12345f9a47df4d1eaeb3bad9a7e54321'
    params = 'openid=test001&appid=33758&ts=1328855301&payitem=323003*8*1&token=53227955F80B805B50FFB511E5AD51E025360&billno=-APPDJT18700-20120210-1428215572&version=v3&zoneid=1&providetype=0&amt=80&payamt_coins=20&pubacct_payamt_coins=10'
    options = {:sig => 'VvKwcaMqUNpKhx0XfCvOqPRiAnU%3D'}
    params.split('&').each do |param|
      param = param.split('=')
      options[param.first] = param.last
    end
    assert OpenQq.verify_callback_sig(:GET, '/cgi-bin/temp.py', options, key), 'Verify sig failure 1'
    OpenQq.setup{|c| c.appkey = key }
    assert OpenQq.verify_callback_sig(:GET, '/cgi-bin/temp.py', options), 'Verify sig failure 2'
    assert OpenQq.verify_callback_sig(:get, '/cgi-bin/temp.py', options), 'Verify sig failure 3'
  end

end
