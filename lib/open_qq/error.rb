# encoding: utf-8
#
# --
# @author zires
# @email  zshuaibin@gmail.com
#
module OpenQq
  # behavior response to body method
  class Error
    
    def initialize(ret, msg, format = 'json')
      @ret, @msg, @format = ret, msg, format.to_s
    end

    def body
      if @format == 'xml'
        %Q(<?xml version="1.0" encoding="UTF-8"?><data><ret>#{@ret}</ret><msg>#{@msg}</msg></data>)
      else
        {:ret => @ret, :msg => @msg}.to_json
      end
    end

  end
end