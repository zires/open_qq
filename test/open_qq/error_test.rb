require 'test_helper'

class OpenQq::ErrorTest < MiniTest::Unit::TestCase

  def test_symbol_format
    error = OpenQq::Error.new(100, 'error!', :json)
    assert_equal '{"ret":100,"msg":"error!"}', error.body
  end

  def test_json_format
    error = OpenQq::Error.new(100, 'error!', 'json')
    assert_equal '{"ret":100,"msg":"error!"}', error.body
  end

  def test_xml_format
    error = OpenQq::Error.new(100, 'error!', 'xml')
    assert_equal '<?xml version="1.0" encoding="UTF-8"?><data><ret>100</ret><msg>error!</msg></data>', error.body
  end

  def test_no_format
    error = OpenQq::Error.new(100, 'error!')
    assert_equal '{"ret":100,"msg":"error!"}', error.body
  end

  def test_unsupported_format
    error = OpenQq::Error.new(100, 'error!', :ruby)
    assert_equal '{"ret":100,"msg":"error!"}', error.body
  end

end