begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "test/unit"
require 'minitest/autorun'

# Enable turn if it is available
begin
  require 'turn'
rescue LoadError
end

require 'open_qq'

# fake qq response
require 'fakeweb'

# 测试用例的签名通过腾讯联调工具产生 http://open.qq.com/tools
# get
FakeWeb.register_uri(:get, "http://119.147.19.43/v3/user/get_info?appid=12345&sig=CRkzTEcrnfRkNMt9LnVtHjGTocI%3D", 
  :body => '{ "ret": 0, "is_lost": 0, "nickname": "foo" }')

# get with json format
FakeWeb.register_uri(:get, 
  "http://119.147.19.43/v3/user/get_info?openid=1111&openkey=2222&pf=pengyou&appid=12345&format=json&sig=qjReS%2Fg%2FGM9qStD9gmYNI%2B65nWo%3D", 
  :body => '{ "ret": 0, "is_lost": 0, "nickname": "foo" }')

# get without format
FakeWeb.register_uri(:get, 
  "http://119.147.19.43/v3/user/get_info?openid=1111&openkey=2222&pf=pengyou&appid=12345&sig=CtBQwNTqB24SnqMnWrSJyh4atg8%3D", 
  :body => '{ "ret": 0, "is_lost": 0, "nickname": "foo" }')

# get with xml format
FakeWeb.register_uri(:get, 
  "http://119.147.19.43/v3/user/get_info?openid=1111&openkey=2222&pf=pengyou&appid=12345&format=xml&sig=t4WtmJ2pG6RDgGAOfiLWMf8E4%2FM%3D", 
  :body => '<?xml version="1.0" encoding="UTF-8"?>')

# get with unsupported format
FakeWeb.register_uri(:get, 
  "http://119.147.19.43/v3/user/get_info?openid=1111&openkey=2222&pf=pengyou&appid=12345&format=ruby&sig=egeboQvMq5HbfntN5jdwbQaB6go%3D", 
  :body => '{ "ret": 0, "is_lost": 0, "nickname": "foo" }')

# post without set format
FakeWeb.register_uri(:post, 
  "http://119.147.19.43/v3/user/get_info",
  :parameters => {:openid => '1111', :openkey => '2222', :pf => 'pengyou', :appid => '12345', :sig => 'CtBQwNTqB24SnqMnWrSJyh4atg8%3D'},
  :body => '{ "ret": 0, "is_lost": 0, "nickname": "foo" }')

# http translate error
FakeWeb.register_uri(:get, 
  "http://119.147.19.43/v3/user/get_info?openid=1111&openkey=2222&pf=pengyou&appid=123456&sig=b67OwPW%2BfHFsKwgpu1b82k4dHZU%3D",
  :exception => Net::HTTPError)