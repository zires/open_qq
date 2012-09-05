require 'test_helper'

class OpenQq::UserTest < MiniTest::Unit::TestCase
  
  def test_is_a_class
    assert_equal Class, OpenQq::User.class
  end

  def test_raise_error_when_wrong_init_params
    assert_raises RuntimeError, "openid can't be blank"  do
      OpenQq::User.new('228bf094169a40a3bd188ba37ebe8723')
    end

    assert_raises RuntimeError, "openkey can't be blank"  do
      OpenQq::User.new('11', :openid => 'openid')
    end

    assert_raises RuntimeError, "appid can't be blank"  do
      OpenQq::User.new('11', :openid => 'openid', :openkey => 'openkey')
    end

    assert_raises RuntimeError, "pf can't be blank"  do
      OpenQq::User.new('11', :openid => 'openid', :openkey => 'openkey', :appid => 'appid')
    end
  end

  def test_env
    open_user = OpenQq::User.new('11', :openid => 'openid', :openkey => 'openkey', :appid => 'appid', :pf => 'qzone')
    assert_equal '119.147.19.43', open_user.env
    open_user1 = OpenQq::User.new('11', :openid => 'openid', :openkey => 'openkey', :appid => 'appid', :pf => 'qzone', :env => :production)
    assert_equal 'openapi.tencentyun.com', open_user1.env
    open_user2 = OpenQq::User.new('11', :openid => 'openid', :openkey => 'openkey', :appid => 'appid', :pf => 'qzone', :env => :development)
    assert_equal '119.147.19.43', open_user2.env
  end

  def test_signature
    user = OpenQq::User.new('228bf094169a40a3bd188ba37ebe8723', :openid => '11111111111111111', :openkey => '2222222222222222', :appid => '123456', :pf => 'qzone')
    assert_equal 'zRXOeH3tIdKAf9fUWUwcvoAjyjs=', user.sig('/v3/user/get_info')
  end

end
