# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
module OpenQq
  module Rails
    module ActionController
      extend ActiveSupport::Concern

      private
      # @example
      #   class OpenQqController < ApplicationController
      #     include OpenQq::Rails::ActionController
      #
      #     def index
      #       if verify_callback_sig
      #          ...do something
      #       end
      #     end
      #   end
      # @return [Boolean]
      def verify_callback_sig(key = nil)
        logger.debug "Appkey: #{key ||= OpenQq.appkey} method: #{request.method} url: #{request.fullpath.split("?")[0]}"
        logger.debug "params: #{params.slice!(:action, :controller).inspect}"
        OpenQq.verify_callback_sig(request.method, request.fullpath.split("?")[0], params.slice!(:action, :controller), key)
      end

    end
  end
end