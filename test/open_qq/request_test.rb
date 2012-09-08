require 'test_helper'

class OpenQq::RequestTest < MiniTest::Unit::TestCase

  def setup
    # 测试用例的签名通过腾讯联调工具产生 http://open.qq.com/tools
    options = { :appid  => 12345,
                :appkey => '228bf094169a40a3bd188ba37ebe8723',
                :env    => 'http://119.147.19.43',
                :url    => '/v3/user/get_info',
              }
    @request = OpenQq::Request.new(options)
  end

  def test_call_get_request_without_params
    assert_equal 'foo', @request.get.nickname
  end

  def test_call_get_request_with_params
    params = { :openid => 1111, 'openkey' => '2222', :pf => :pengyou, :format => 'json' }
    assert_equal 'foo', @request.get(params).nickname
  end

  def test_call_post_request
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal 'foo', @request.post(params).nickname
  end

  def test_call_post_request_with_raw_output
    params = {:openid => '1111', :openkey => '2222', :pf => 'pengyou'}
    assert_equal '{ "ret": 0, "is_lost": 0, "nickname": "foo" }', @request.post(params, :raw => true)
  end

end