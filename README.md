open_qq
=======

腾讯开放平台ruby版SDK(v3版本)

## 安装

```ruby
gem install open_qq
```

## 使用

使用非常简单，传入应用的`appid`, `appkey`和环境地址`env`

```ruby
require 'rubygems'
require 'open_qq'

OpenQq.setup(:appid => '123', :appkey => '456', :env => 'http://119.147.19.43')

# 或者https
OpenQq.setup(:appid => '123', :appkey => '456', :env => 'https://119.147.19.43')

# get请求
user_info = OpenQq.get('/v3/user/get_info', :openid => '111',:openkey => '222')

# 或者post请求
user_info = OpenQq.post('/v3/user/get_info',:openid => '111',:openkey => '222')

user_info.ret # => 0
user_info.nickname # => 'foo'
```

如果你只想原样返回未加工的数据，使用`raw => true`

```ruby
user_info = OpenQq.post('/v3/user/get_info', {:openid => '111', :openkey => '222'}, :raw => true)
puts user_info
# => '{ "ret": 0, "is_lost": 0, "nickname": "foo" }'
```

如果你不想使用全局的配置

```ruby
options   = {:appid => 'newappid', :appkey => 'newappkey', :env => 'http://newenv'}

user_info = OpenQq.call('/v3/user/get_info', options) do |request|
  
  request.get {:openid => '111',:openkey => '222'}

  #或者
  request.post {:openid => '111',:openkey => '222'}

end

user_info.nickname
# => 'foo'
```

回调协议签名验证

```ruby
params = {openid: 'test001', appid: '33758', sig: 'VvKwcaMqUNpKhx0XfCvOqPRiAnU%3D'}
OpenQq.verify_callback_sig(:get, '/cgi-bin/temp.py', params)
# => true or false

#指定特定的appkey
OpenQq.verify_callback_sig(:get, '/cgi-bin/temp.py', params, 'xxxxxx')

# 在rails中使用
class OpenQqController < ApplicationController
  include OpenQq::Rails::ActionController

  def index
    if verify_callback_sig
      ...do something
    end
  end
end

```

## 在rails中使用

首先在Gemfile中添加
```
gem 'open_qq'
```

执行`bundle install`

在config目录下生成配置文件config/open_qq.yml
```
rails g open_qq:install
```

在配置文件中填入appid, appkey和env的值，启动服务后全局都可以使用，例如：

```ruby
class OpenQqController < ApplicationController
  
  # 假设这里是应用的入口
  def index
    user_info = OpenQq.post('/v3/user/get_info', params.slice!(:action, :controller))
    if user_info.ret == 0
      # do something
    end
  end

end

```

## 注意和说明

* 当传入的format为xml时，不会对返回的结果做处理，直接字符串返回
* 当传入的format不为xml时，会使用`JSON#parse`转换成hash，并且使用[OpenStruct](http://www.ruby-doc.org/stdlib-1.8.7/libdoc/ostruct/rdoc/OpenStruct.html, 'OpenStruct')封装
* 当ret返回`2001`时，是由本api抛出
* 关于*signature verification failed*，先仔细对照[文档](http://wiki.open.qq.com/wiki/%E8%85%BE%E8%AE%AF%E5%BC%80%E6%94%BE%E5%B9%B3%E5%8F%B0%E7%AC%AC%E4%B8%89%E6%96%B9%E5%BA%94%E7%94%A8%E7%AD%BE%E5%90%8D%E5%8F%82%E6%95%B0sig%E7%9A%84%E8%AF%B4%E6%98%8E#.E4.B8.BA.E4.BB.80.E4.B9.88.E6.80.BB.E6.98.AF.E8.BF.94.E5.9B.9E.E2.80.9C-5.EF.BC.9Asignature_verification_failed.E2.80.9D.EF.BC.9F)

```
可以通过联调工具看下签名是否一致

OpenQq.setup(:appid => '123', :appkey => '456', :env => 'http://119.147.19.43')
opts = {:openid => '1111',:openkey => '2222',:pf => 'pengyou'}
sig = OpenQq.wrap(:post, '/v3/user/get_info', opts)[:sig]

puts sig # 与联调结果比对

```

* 如果不想使用open_qq.yml，只要在使用前全局配置好`OpenQq`即可
* 测试基本覆盖，可以下载下来执行`rake`
* bug反馈[Issue](https://github.com/zires/open_qq/issues)

## Changelog

* 2012/09/11 
增加对https的支持
支持支付回调协议签名验证


## This project rocks and uses MIT-LICENSE.
