$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "open_qq/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "open_qq"
  s.version     = OpenQq::VERSION
  s.authors     = ["zires"]
  s.email       = ["zshuaibin@gmail.com"]
  s.homepage    = "https://github.com/zires/open_qq"
  s.summary     = "open qq ruby sdk. v3 version"
  s.description = "腾讯开放平台ruby版SDK(v3版本)http://open.qq.com/"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activesupport"

  s.add_development_dependency "turn"
  s.add_development_dependency "minitest"
  s.add_development_dependency "yard"
  s.add_development_dependency "rake"
  s.add_development_dependency "fakeweb"

end
