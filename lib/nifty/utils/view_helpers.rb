module Nifty
  module Utils
    module ViewHelpers

      # Displays the full contents of the `flash` hash within an appropriate <div>
      # element. The ID of the outputted div will be `flash-alert` where alert is the
      # type of flash.
      #
      # If there are multiple flashes set, they will all be displayed.
      def display_flash
        flashes = flash.collect do |key,msg|
          content_tag :div, content_tag(:p, h(msg)), :id => "flash-#{key}"
        end.join.html_safe
      end

      # Renders an `<img>` containing a link to the gravatar for the given e-mail address.
      # Available options as follows:
      #
      # * <tt>:size</tt>: the size in pixels of the outputted gravatar. Defaults to 35.
      # * <tt>:default</tt>: the gravatar to fallback to if the user has no gravatar
      #   (see gravatar for available options or pass a URL). Defaults to 'identicon'.
      # * <tt>:rating</tt>: the maximum rating to use. Defaults to PG.
      # * <tt>:class</tt>: the value for the class attribute for the outputted img tag.
      #   Defaults to 'gravatar'.
      # * <tt>:secure</tt>: wherher or not to output an HTTPS version of the gravatar or not.
      #   Defaults to the value of `request.ssl?`.
      def gravatar(email, options = {})
        options[:size]    ||= 35
        options[:default] ||= 'identicon'
        options[:rating]  ||= 'PG'
        options[:class]   ||= 'gravatar'
        options[:secure]  ||= request.ssl?
        host = (options[:secure] ? 'https://secure.gravatar.com' : 'http://gravatar.com')
        path = "/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(email.to_s.downcase)}&rating=#{options[:rating]}&size=#{options[:size] * 2}&d=#{options[:default]}"
        image_tag([host,path].join, :class => options[:class], :width => options[:size], :height => options[:size])
      end

      # Renders a tick or cross character based on the provided boolean. Additional options
      # can be passed if needed.
      #
      # * <tt>:true_text</tt> - text to display next to a tick
      # * <tt>:false_text</tt> - text to display next to a cross
      def boolean_tag(bool, tip = nil, options = {})
        true_text, false_text = "", ""
        true_text = " <b>#{options[:true_text]}</b>" if options[:true_text]
        false_text = " <b>#{options[:false_text]}</b>" if options[:false_text]
        content_tag :span, (bool ? "<span class='true'>&#x2714;#{true_text}</span>" : "<span class='false'>&#x2718;#{false_text}</span>").html_safe, :class => "boolean", :title => tip
      end

    end
  end
end
