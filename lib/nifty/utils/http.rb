require 'net/https'
require 'uri'

module Nifty
  module Utils
    module HTTP

      def self.get(url, options = {})
        request(Net::HTTP::Get, url, options)
      end

      def self.post(url, options = {})
        request(Net::HTTP::Post, url, options)
      end

      def self.request(method, url, options = {})
        options[:headers] ||= {}
        uri = URI.parse(url)
        request = method.new(uri.path.length == 0 ? "/" : uri.path)
        options[:headers].each { |k,v| request.add_field k, v }

        if options[:username]
          request.basic_auth(options[:username], options[:password])
        end

        if options[:params].is_a?(Hash)
          # If params has been provided, sent it them as form encoded values
          request.set_form_data(options[:params])

        elsif options[:json].is_a?(String)
          # If we have a JSON string, set the content type and body to be the JSON
          # data
          request.add_field 'Content-Type', 'application/json'
          request.body = options[:json]
        end

        if options[:user_agent]
          request['User-Agent'] = options[:user_agent]
        end

        connection = Net::HTTP.new(uri.host, uri.port)

        if uri.scheme == 'https'
          connection.use_ssl = true
          connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end

        begin
          timeout = options[:timeout] || 60
          Timeout.timeout(timeout) do
            result = connection.request(request)
            if result.content_type == 'application/json'
              body = JSON.parse(result.body)
            else
              body = result.body
            end
            {
              :code => result.code.to_i,
              :type => result.content_type,
              :body => body
            }
          end
        rescue SocketError, Errno::ECONNRESET, EOFError, Errno::EINVAL => e
          {
            :code => -2,
            :body => e.message
          }
        rescue Timeout::Error => e
          {
            :code => -1,
            :body => "Timed out after #{timeout}s"
          }
        end
      end

    end
  end
end
