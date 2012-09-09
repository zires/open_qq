open_qq
=======

腾讯开放平台ruby版SDK(v3版本)

## 安装

```ruby
gem install open_qq
```

## 使用

使用非常简单，传入应用的appid, appkey和环境地址env _http://openapi.tencentyun.com_ 或者 _http://119.147.19.43_ 即可

```ruby
require 'rubygems'
require 'open_qq'

OpenQq.setup({:appid => '123', :appkey => '456', :env => 'http://119.147.19.43'})

# get请求
user_info = OpenQq.get('/v3/user/get_info', {:openid => '111',:openkey => '222'})
# 或者post请求
user_info = OpenQq.post('/v3/user/get_info', {:openid => '111',:openkey => '222'})

user_info.nickname 
# => 'foo'
```

如果你只想原样返回未加工的数据，使用`raw => true`

```ruby
user_info = OpenQq.post('/v3/user/get_info', {:openid => '111',:openkey => '222'}, :raw => true)
puts user_info
# => '{ "ret": 0, "is_lost": 0, "nickname": "foo" }'
```

如果你不想使用全局的配置

```ruby
options   = {:appid => 'newappid', :appkey => 'newappkey', :env => 'http://newenv'}

user_info = OpenQq.start('/v3/user/get_info', options) do |request|
  request.get {:openid => '111',:openkey => '222'}
  #或者
  request.post {:openid => '111',:openkey => '222'}
end

user_info.nickname
# => 'foo'
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

```
class OpenQqController < ApplicationController
  
  # 假设这里是应用的入口
  def index
    user_info = OpenQq.post('/v3/user/get_info', params.slice!(:action, :controller))
    if user_info.ret.to_i == 0
      # do something
    end
  end

end

```

## 注意和说明

* 当传入的format为xml时，不会对返回的结果做处理，直接字符串返回
* 当传入的format不为xml时，会使用`JSON#parse`转换成hash，并且使用[OpenStruct](http://www.ruby-doc.org/stdlib-1.8.7/libdoc/ostruct/rdoc/OpenStruct.html, 'OpenStruct')封装
* 当ret返回`2001`时，是由本api抛出
* 如果不想使用open_qq.yml，只要在使用前全局配置好`OpenQq`即可
* 测试基本覆盖，可以下载下来执行`rake`
* bug反馈[Issue](https://github.com/zires/open_qq/issues)

#### This project rocks and uses MIT-LICENSE.