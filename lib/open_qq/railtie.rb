# encoding: utf-8
module OpenQq
  class Railtie < ::Rails::Railtie
    
    generators do
      require "generators/open_qq/install_generator"
    end

    initializer "open_qq.setup" do
      config_file = Rails.root.join("config", "open_qq.yml")
      if config_file.file?
        begin
          options = YAML.load_file(config_file)[Rails.env]
          OpenQq.setup(options)
        rescue Exception => e
          puts "There is a configuration error with the current open_qq.yml"
          puts e.message
        end
      end
    end 

  end
end