# encoding: utf-8
module OpenQq
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      # Create open_qq.yml under config/initializers/
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a ThemePark initializer file."
      def copy_initializer
        template "open_qq.yml", "config/open_qq.rb"
      end

    end
  end
end