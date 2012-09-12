require 'test_helper'

class Foo
  include OpenQq::Signature
end

class OpenQq::SignatureTest < MiniTest::Unit::TestCase

  def setup
    @foo = Foo.new
    # 测试数据是通过腾讯开放平台联调工具集生成
    # 详见：http://open.qq.com/tools
    @url = '/v3/user/get_info'
    @http_method = :GET
    @appkey = '228bf094169a40a3bd188ba37ebe8723'

    #openid=11111111111111111&openkey=2222222222222222&pf=qzone&appid=123456&format=json&userip=10.0.0.1
    @options = { :openid => '11111111111111111', :openkey => '2222222222222222', 
                 'appid' => '123456', 'pf' => 'qzone', 
                 :userip => '10.0.0.1', :format => :json
               }
  end

  def test_signature_is_a_module
    assert_equal Module, ::OpenQq::Signature.class
  end

  def test_make_source
    expect_source = 'GET&%2Fv3%2Fuser%2Fget_info&appid%3D123456%26format%3Djson%26openid%3D11111111111111111%26openkey%3D2222222222222222%26pf%3Dqzone%26userip%3D10.0.0.1'
    assert_equal expect_source, @foo.make_source(@http_method, @url, @options)
  end

  def test_parsed_params
    opt = { '/ +=&' => '123@*!' }
    assert_equal( "%2F%20%2B%3D%26=123%40%2A%21", @foo.parsed_params(opt) )
  end

  def test_url_escape
    assert_equal 'o%2FnGo1QkVEiiN6Bqn%2FfRJtEJwLc%3D', @foo.url_escape('o/nGo1QkVEiiN6Bqn/fRJtEJwLc=')
  end

  def test_signature
    source = @foo.make_source(@http_method, @url, @options)
    assert_equal( 'o/nGo1QkVEiiN6Bqn/fRJtEJwLc=', @foo.signature("#{@appkey}&", source) )
  end

  #测试用例通过http://wiki.open.qq.com/wiki/回调发货URL的协议说明_V3获得
  def test_make_callback_source
    params = 'openid=test001&appid=33758&ts=1328855301&payitem=323003*8*1&token=53227955F80B805B50FFB511E5AD51E025360&billno=-APPDJT18700-20120210-1428215572&version=v3&zoneid=1&providetype=0&amt=80&payamt_coins=20&pubacct_payamt_coins=10'
    options = {}
    params.split('&').each do |param|
      param = param.split('=')
      options[param.first] = param.last
    end
    expect = 'GET&%2Fcgi-bin%2Ftemp.py&amt%3D80%26appid%3D33758%26billno%3D%252DAPPDJT18700%252D20120210%252D1428215572%26openid%3Dtest001%26payamt_coins%3D20%26payitem%3D323003%2A8%2A1%26providetype%3D0%26pubacct_payamt_coins%3D10%26token%3D53227955F80B805B50FFB511E5AD51E025360%26ts%3D1328855301%26version%3Dv3%26zoneid%3D1'
    assert_equal expect, @foo.make_callback_source(:GET, '/cgi-bin/temp.py', options)
  end

  def test_verify_sig
    key = '12345f9a47df4d1eaeb3bad9a7e54321&'
    sig = 'VvKwcaMqUNpKhx0XfCvOqPRiAnU%3D'
    params = 'openid=test001&appid=33758&ts=1328855301&payitem=323003*8*1&token=53227955F80B805B50FFB511E5AD51E025360&billno=-APPDJT18700-20120210-1428215572&version=v3&zoneid=1&providetype=0&amt=80&payamt_coins=20&pubacct_payamt_coins=10'
    options = {}
    params.split('&').each do |param|
      param = param.split('=')
      options[param.first] = param.last
    end
    assert @foo.verify_sig(sig, key, :GET, '/cgi-bin/temp.py', options), 'Verify sig failure'
  end

end