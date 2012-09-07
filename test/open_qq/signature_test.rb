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

  def test_each_pair_escape
    opt = { '/ +=&' => '123@*!' }
    assert_equal( {'%2F%20%2B%3D%26' => '123%40%2A%21'}, @foo.each_pair_escape(opt) )
  end

  def test_url_escape
    assert_equal 'o%2FnGo1QkVEiiN6Bqn%2FfRJtEJwLc%3D', @foo.url_escape('o/nGo1QkVEiiN6Bqn/fRJtEJwLc=')
  end

  def test_signature
    source = @foo.make_source(@http_method, @url, @options)
    assert_equal( 'o/nGo1QkVEiiN6Bqn/fRJtEJwLc=', @foo.signature("#{@appkey}&", source) )
  end

end