require 'rubygems'
require 'benchmark'
require 'ostruct'
require 'json'

n = 500000
@os = { :ret => 0, 
       :is_lost => 0,
       :nickname => 'Peter',
       :gender => 'boy',
       :country => 'country',
       :province => 'province',
       :city => 'city', 
       :figureurl => 'http://imgcache.qq.com/qzone_v4/client/userinfo_icon/1236153759.gif',
       :is_yellow_vip => 1,
       :is_yellow_year_vip => 1,
       :yellow_vip_level => 7
    }

@os_obj = OpenStruct.new(@os)

Benchmark.bm do |x|

  x.report { for i in 1..n; @os_obj.nickname; end }
  x.report { for i in 1..n; @os['nickname']; end }

end

@os_json = @os.to_json

m = 10

Benchmark.bm do |x|

  x.report { for i in 1..m; JSON.parse(@os_json); end }
  x.report { for i in 1..m; OpenStruct.new( JSON.parse(@os_json) ); end }

end