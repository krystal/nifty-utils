module Nifty
  module Utils
    module ViewHelpers
      
      def display_flash
        flashes = flash.collect do |key,msg|
          content_tag :div, content_tag(:p, h(msg)), :id => "flash-#{key}"
        end.join.html_safe
      end
      
      def gravatar(email, options = {})
        options[:size]    ||= 35
        options[:default] ||= 'identicon'
        options[:rating]  ||= 'PG'
        options[:class]   ||= 'gravatar'
        options[:secure]  ||= request.ssl?
        host = (options[:secure] ? 'https://secure.gravatar.com' : 'http://gravatar.com')
        path = "/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email)}&rating=#{options[:rating]}&size=#{options[:size] * 2}&d=#{options[:default]}"
        image_tag([host,path].join, :class => options[:class], :width => options[:size], :height => options[:size])
      end
      
    end
  end
end
